import flet as ft

from models.exercise import Exercise
from theme import colors


def build_exercise_card(exercise: Exercise, on_click=None) -> ft.Container:
    check_icon = ft.Container(
        width=28,
        height=28,
        border_radius=14,
        bgcolor=colors.GREEN_SUCCESS if exercise.completed else colors.BG_CARD_ICON,
        alignment=ft.Alignment.CENTER,
        content=ft.Icon(
            ft.Icons.CHECK,
            size=16,
            color=ft.Colors.WHITE if exercise.completed else colors.TEXT_MUTED,
        ) if exercise.completed else None,
    )

    return ft.Container(
        bgcolor=colors.BG_CARD,
        border_radius=12,
        padding=12,
        on_click=on_click,
        content=ft.Row(
            controls=[
                ft.Container(
                    width=40,
                    height=40,
                    border_radius=10,
                    bgcolor=colors.BG_CARD_ICON,
                    alignment=ft.Alignment.CENTER,
                    content=ft.Icon(getattr(ft.Icons, exercise.icon.upper()), size=20, color=colors.BLUE_ACCENT),
                ),
                ft.Column(
                    expand=True,
                    spacing=2,
                    controls=[
                        ft.Text(exercise.name, size=14, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                        ft.Text(
                            f"{exercise.duration_minutes} min · {exercise.difficulty.value}",
                            size=12,
                            color=colors.TEXT_SECONDARY,
                        ),
                    ],
                ),
                check_icon,
            ],
            alignment=ft.MainAxisAlignment.START,
            vertical_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=12,
        ),
    )
