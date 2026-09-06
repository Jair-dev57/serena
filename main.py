import flet as ft

from services.db_service import init_db, mark_completed
from screens.exercises_screen import build_exercises_screen
from screens.home_screen import build_home_screen
from screens.progress_screen import build_progress_screen
from screens.profile_screen import build_profile_screen
from screens.exercise_run_screen import build_exercise_run_screen
from widgets.bottom_nav import build_bottom_nav
from theme import colors
from models.exercise import ExerciseCategory


def main(page: ft.Page):
    page.title = "Serena"
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = colors.BG_PAGE
    page.padding = 0

    init_db()

    content = ft.Container(expand=True)
    nav_state = {"index": 0}

    def show_screen(index: int):
        nav_state["index"] = index
        if index == 0:
            content.content = build_home_screen(page, on_start=on_start_exercise)
        elif index == 1:
            content.content = build_exercises_screen(page)
        elif index == 2:
            content.content = build_progress_screen(page)
        else:
            content.content = build_profile_screen(page)
        nav.visible = True
        page.update()

    def on_start_exercise(exercise):
        if exercise.category != ExerciseCategory.RESPIRACION:
            page.show_dialog(ft.SnackBar(ft.Text("Este tipo de ejercicio todavia no esta listo")))
            return

        nav.visible = False

        def on_finish(finished_exercise):
            if finished_exercise:
                mark_completed(finished_exercise.id, completed=True)
            show_screen(nav_state["index"])

        content.content = build_exercise_run_screen(page, exercise, on_finish)
        page.update()

    def on_nav_change(e):
        show_screen(e.control.selected_index)

    nav = build_bottom_nav(0, on_nav_change)
    show_screen(0)

    page.add(
        ft.Column(
            expand=True,
            spacing=0,
            controls=[content, nav],
        )
    )


ft.run(main)
