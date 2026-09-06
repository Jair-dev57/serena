import flet as ft

from screens.exercises_screen import build_exercises_screen
from screens.home_screen import build_home_screen
from screens.progress_screen import build_progress_screen
from services.db_service import init_db
from theme import colors
from widgets.bottom_nav import build_bottom_nav


def main(page: ft.Page):
    page.title = "Serena"
    page.theme_mode = ft.ThemeMode.DARK
    page.bgcolor = colors.BG_PAGE
    page.padding = 0

    init_db()

    content = ft.Container(expand=True)

    def show_screen(index: int):
        if index == 0:
            content.content = build_home_screen(page)
        elif index == 1:
            content.content = build_exercises_screen(page)
        elif index == 2:
            content.content = build_progress_screen(page)
        else:
            content.content = ft.Container(
                expand=True,
                bgcolor=colors.BG_PAGE,
                alignment=ft.Alignment.CENTER,
                content=ft.Text("Proximamente", color=colors.TEXT_SECONDARY),
            )
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
