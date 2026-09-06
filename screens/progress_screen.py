import flet as ft
import flet_charts as fch

from services.db_service import (
    get_streak_days,
    get_minutes_this_week,
    get_average_fluency,
    get_minutes_per_day_last_7,
    get_recent_fluency_scores,
)
from theme import colors

ACHIEVEMENTS = [
    ("local_fire_department", "Racha activa", "Segui practicando cada dia"),
    ("mic", "Primera conversacion", "Completaste tu reto mas grande"),
]


def build_stat_card(value: str, label: str) -> ft.Container:
    return ft.Container(
        expand=True,
        bgcolor=colors.BG_CARD,
        border_radius=12,
        padding=14,
        content=ft.Column(
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=2,
            controls=[
                ft.Text(value, size=20, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                ft.Text(label, size=10, color=colors.TEXT_SECONDARY, text_align=ft.TextAlign.CENTER),
            ],
        ),
    )


def build_bar_chart() -> fch.BarChart:
    data = get_minutes_per_day_last_7()
    max_val = max((minutes for _, minutes in data), default=1) or 1
    groups = []
    for i, (day_label, minutes) in enumerate(data):
        is_peak = minutes == max_val and minutes > 0
        groups.append(
            fch.BarChartGroup(
                x=i,
                rods=[
                    fch.BarChartRod(
                        from_y=0,
                        to_y=minutes,
                        width=16,
                        color=colors.ORANGE_STREAK if is_peak else colors.BLUE_ACCENT,
                        border_radius=4,
                    )
                ],
            )
        )

    return fch.BarChart(
        groups=groups,
        height=140,
        bottom_axis=fch.ChartAxis(
            labels=[
                fch.ChartAxisLabel(value=i, label=ft.Text(day_label, size=11, color=colors.TEXT_SECONDARY))
                for i, (day_label, _) in enumerate(data)
            ],
            label_size=20,
        ),
        left_axis=fch.ChartAxis(show_labels=False),
        border=ft.Border.all(0, ft.Colors.TRANSPARENT),
        interactive=False,
    )


def build_line_chart() -> fch.LineChart:
    scores = get_recent_fluency_scores(6)
    points = [fch.LineChartDataPoint(i, score) for i, score in enumerate(scores)]
    return fch.LineChart(
        data_series=[
            fch.LineChartData(
                points=points,
                stroke_width=2,
                color=colors.BLUE_ACCENT,
                curved=True,
                rounded_stroke_cap=True,
            )
        ],
        height=140,
        left_axis=fch.ChartAxis(show_labels=False),
        bottom_axis=fch.ChartAxis(show_labels=False),
        border=ft.Border.all(0, ft.Colors.TRANSPARENT),
        interactive=False,
        min_y=max(0, min(scores) - 5),
        max_y=max(scores) + 5,
    )


def build_achievement_card(icon_name: str, title: str, subtitle: str) -> ft.Container:
    return ft.Container(
        bgcolor=colors.BG_CARD,
        border_radius=12,
        padding=12,
        content=ft.Row(
            spacing=12,
            vertical_alignment=ft.CrossAxisAlignment.CENTER,
            controls=[
                ft.Container(
                    width=36,
                    height=36,
                    border_radius=18,
                    bgcolor=colors.BG_CARD_ICON,
                    alignment=ft.Alignment.CENTER,
                    content=ft.Icon(getattr(ft.Icons, icon_name.upper()), size=18, color=colors.BLUE_ACCENT),
                ),
                ft.Column(
                    spacing=1,
                    controls=[
                        ft.Text(title, size=13, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                        ft.Text(subtitle, size=11, color=colors.TEXT_SECONDARY),
                    ],
                ),
            ],
        ),
    )


def build_progress_screen(page: ft.Page) -> ft.Container:
    return ft.Container(
        expand=True,
        bgcolor=colors.BG_PAGE,
        padding=ft.Padding.only(left=20, right=20, top=20),
        content=ft.Column(
            expand=True,
            spacing=16,
            scroll=ft.ScrollMode.AUTO,
            controls=[
                ft.Column(
                    spacing=2,
                    controls=[
                        ft.Text("TU EVOLUCION", size=12, weight=ft.FontWeight.W_500, color=colors.BLUE_ACCENT),
                        ft.Text("Progreso", size=24, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                    ],
                ),
                ft.Row(
                    spacing=12,
                    controls=[
                        build_stat_card(str(get_streak_days()), "DIAS SEGUIDOS"),
                        build_stat_card(str(get_minutes_this_week()), "MIN. ESTA SEMANA"),
                        build_stat_card(f"{get_average_fluency()}%", "FLUIDEZ"),
                    ],
                ),
                ft.Container(
                    bgcolor=colors.BG_CARD,
                    border_radius=16,
                    padding=16,
                    content=ft.Column(
                        spacing=10,
                        controls=[
                            ft.Text("Minutos por dia", size=13, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                            build_bar_chart(),
                        ],
                    ),
                ),
                ft.Container(
                    bgcolor=colors.BG_CARD,
                    border_radius=16,
                    padding=16,
                    content=ft.Column(
                        spacing=10,
                        controls=[
                            ft.Text(
                                "Puntaje de fluidez - ultimas sesiones",
                                size=13,
                                weight=ft.FontWeight.W_500,
                                color=colors.TEXT_PRIMARY,
                            ),
                            build_line_chart(),
                        ],
                    ),
                ),
                ft.Column(
                    spacing=10,
                    controls=[build_achievement_card(icon, title, subtitle) for icon, title, subtitle in ACHIEVEMENTS],
                ),
            ],
        ),
    )
