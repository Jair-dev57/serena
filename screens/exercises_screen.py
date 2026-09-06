import flet as ft

from models.exercise import ExerciseCategory
from services.db_service import get_all_exercises, mark_completed
from theme import colors
from widgets.exercise_card import build_exercise_card

FILTERS = ["Todos"] + [c.value for c in ExerciseCategory]


def build_exercises_screen(page: ft.Page, on_open_exercise=None) -> ft.Container:
    state = {"selected_filter": "Todos"}

    list_column = ft.Column(spacing=10, expand=True, scroll=ft.ScrollMode.AUTO)
    chips_row = ft.Row(spacing=8, scroll=ft.ScrollMode.AUTO)

    def toggle_complete(exercise):
        mark_completed(exercise.id, completed=not exercise.completed)
        render_list()

    def render_list():
        all_exercises = get_all_exercises()
        exercises = all_exercises
        if state["selected_filter"] != "Todos":
            exercises = [e for e in all_exercises if e.category.value == state["selected_filter"]]

        list_column.controls = [
            build_exercise_card(
                exercise,
                on_click=lambda e, ex=exercise: toggle_complete(ex),
            )
            for exercise in exercises
        ]
        page.update()

    def build_chip(label: str) -> ft.Container:
        is_selected = state["selected_filter"] == label

        def on_chip_click(e):
            state["selected_filter"] = label
            render_chips()
            render_list()

        return ft.Container(
            padding=ft.Padding.symmetric(horizontal=14, vertical=8),
            border_radius=20,
            bgcolor=colors.BLUE_ACCENT if is_selected else colors.BG_CARD,
            on_click=on_chip_click,
            content=ft.Text(
                label,
                size=13,
                weight=ft.FontWeight.W_500,
                color=colors.BG_PAGE if is_selected else colors.TEXT_SECONDARY,
            ),
        )

    def render_chips():
        chips_row.controls = [build_chip(label) for label in FILTERS]
        page.update()

    render_chips()
    render_list()

    return ft.Container(
        expand=True,
        bgcolor=colors.BG_PAGE,
        padding=ft.Padding.only(left=20, right=20, top=20),
        content=ft.Column(
            expand=True,
            spacing=16,
            controls=[
                ft.Column(
                    spacing=2,
                    controls=[
                        ft.Text("PRÁCTICA", size=12, weight=ft.FontWeight.W_500, color=colors.BLUE_ACCENT),
                        ft.Text("Ejercicios", size=24, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                    ],
                ),
                chips_row,
                list_column,
            ],
        ),
    )
