import flet as ft

from services.db_service import get_all_exercises
from theme import colors


def build_home_screen(page: ft.Page, on_start=None) -> ft.Container:
    exercises = get_all_exercises()
    featured = next((e for e in exercises if not e.completed), exercises[0] if exercises else None)
    others = [e for e in exercises if featured is None or e.id != featured.id][:4]

    header = ft.Row(
        alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
        vertical_alignment=ft.CrossAxisAlignment.START,
        controls=[
            ft.Column(
                spacing=2,
                controls=[
                    ft.Text("¡Hola, Jair!", size=22, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                    ft.Text("Sigamos practicando hoy", size=13, color=colors.TEXT_SECONDARY),
                ],
            ),
            ft.Container(
                padding=ft.Padding.symmetric(horizontal=12, vertical=6),
                border_radius=20,
                bgcolor=colors.ORANGE_STREAK,
                content=ft.Row(
                    spacing=4,
                    controls=[
                        ft.Icon(ft.Icons.LOCAL_FIRE_DEPARTMENT, size=14, color=ft.Colors.WHITE),
                        ft.Text("12 dias", size=12, weight=ft.FontWeight.W_500, color=ft.Colors.WHITE),
                    ],
                ),
            ),
        ],
    )

    featured_card = ft.Container()
    if featured:
        featured_card = ft.Container(
            bgcolor=colors.BG_CARD,
            border_radius=16,
            padding=20,
            content=ft.Column(
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                spacing=10,
                controls=[
                    ft.Text("EJERCICIO DESTACADO", size=11, weight=ft.FontWeight.W_500, color=colors.BLUE_ACCENT),
                    ft.Container(
                        width=90,
                        height=90,
                        border_radius=45,
                        bgcolor=colors.BLUE_ACCENT,
                        alignment=ft.Alignment.CENTER,
                        content=ft.Text(featured.short_name, size=14, weight=ft.FontWeight.W_500, color=colors.BG_PAGE),
                    ),
                    ft.Text(featured.name, size=17, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                    ft.Text(featured.description, size=12, color=colors.TEXT_SECONDARY),
                    ft.Text(f"{featured.duration_minutes} min", size=12, color=colors.TEXT_MUTED),
                    ft.Container(
                        padding=ft.Padding.symmetric(horizontal=24, vertical=10),
                        border_radius=20,
                        bgcolor=colors.BLUE_ACCENT,
                        on_click=(lambda e: on_start(featured)) if on_start else None,
                        content=ft.Row(
                            spacing=6,
                            alignment=ft.MainAxisAlignment.CENTER,
                            controls=[
                                ft.Icon(ft.Icons.PLAY_ARROW, size=16, color=colors.BG_PAGE),
                                ft.Text("Comenzar", size=13, weight=ft.FontWeight.W_500, color=colors.BG_PAGE),
                            ],
                        ),
                    ),
                ],
            ),
        )

    def build_grid_item(exercise) -> ft.Container:
        return ft.Container(
            expand=True,
            bgcolor=colors.BG_CARD,
            border_radius=12,
            padding=14,
            content=ft.Column(
                spacing=6,
                controls=[
                    ft.Container(
                        width=32,
                        height=32,
                        border_radius=8,
                        bgcolor=colors.BG_CARD_ICON,
                        alignment=ft.Alignment.CENTER,
                        content=ft.Icon(getattr(ft.Icons, exercise.icon.upper()), size=16, color=colors.BLUE_ACCENT),
                    ),
                    ft.Text(exercise.name, size=13, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                    ft.Text(f"{exercise.duration_minutes} min · {exercise.difficulty.value}", size=11, color=colors.TEXT_SECONDARY),
                ],
            ),
        )

    grid_rows = []
    for i in range(0, len(others), 2):
        pair = others[i:i + 2]
        grid_rows.append(ft.Row(spacing=12, controls=[build_grid_item(e) for e in pair]))

    return ft.Container(
        expand=True,
        bgcolor=colors.BG_PAGE,
        padding=ft.Padding.only(left=20, right=20, top=20),
        content=ft.Column(
            expand=True,
            spacing=16,
            scroll=ft.ScrollMode.AUTO,
            controls=[header, featured_card, *grid_rows],
        ),
    )
