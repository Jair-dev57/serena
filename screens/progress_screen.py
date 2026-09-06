import flet as ft
import flet_charts as fch

from theme import colors

DAYS = ["L", "M", "X", "J", "V", "S", "D"]
MINUTES_PER_DAY = [12, 15, 5, 18, 25, 14, 10]
FLUENCY_SCORES = [58, 62, 65, 63, 68, 74]

ACHIEVEMENTS = [
    ("local_fire_department", "7 dias seguidos", "Constancia desbloqueada"),
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
    max_val = max(MINUTES_PER_DAY)
    groups = []
    for i, minutes in enumerate(MINUTES_PER_DAY):
        is_peak = minutes == max_val
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
                fch.ChartAxisLabel(value=i, label=ft.Text(day, size=11, color=colors.TEXT_SECONDARY))
                for i, day in enumerate(DAYS)
            ],
            label_size=20,
        ),
        left_axis=fch.ChartAxis(show_labels=False),
        border=ft.Border.all(0, ft.Colors.TRANSPARENT),
        interactive=False,
    )


def build_line_chart() -> fch.LineChart:
    points = [fch.LineChartDataPoint(i, score) for i, score in enumerate(FLUENCY_SCORES)]
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
        min_y=min(FLUENCY_SCORES) - 5,
        max_y=max(FLUENCY_SCORES) + 5,
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
                        build_stat_card("12", "DIAS SEGUIDOS"),
                        build_stat_card("92", "MIN. ESTA SEMANA"),
                        build_stat_card("74%", "FLUIDEZ"),
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
                                "Puntaje de fluidez - ultimas 6 semanas",
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
