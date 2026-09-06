import flet as ft

from theme import colors


def build_bottom_nav(selected_index: int, on_change) -> ft.NavigationBar:
    return ft.NavigationBar(
        selected_index=selected_index,
        bgcolor=colors.BG_CARD,
        on_change=on_change,
        destinations=[
            ft.NavigationBarDestination(icon=ft.Icons.HOME_OUTLINED, selected_icon=ft.Icons.HOME, label="Inicio"),
            ft.NavigationBarDestination(icon=ft.Icons.GRAPHIC_EQ_OUTLINED, selected_icon=ft.Icons.GRAPHIC_EQ, label="Ejercicios"),
            ft.NavigationBarDestination(icon=ft.Icons.BAR_CHART_OUTLINED, selected_icon=ft.Icons.BAR_CHART, label="Progreso"),
            ft.NavigationBarDestination(icon=ft.Icons.PERSON_OUTLINE, selected_icon=ft.Icons.PERSON, label="Perfil"),
        ],
    )
