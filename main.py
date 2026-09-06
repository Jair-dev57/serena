import flet as ft

from services.db_service import init_db
from screens.exercises_screen import build_exercises_screen


def main(page: ft.Page):
    page.title = "Serena"
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = "#0d1b26"
    page.padding = 0

    init_db()

    page.add(build_exercises_screen(page))


ft.run(main)
