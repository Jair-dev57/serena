import flet as ft

from services.db_service import get_preferences, update_preference
from theme import colors


def build_profile_screen(page: ft.Page) -> ft.Container:
    prefs = get_preferences()

    goal_text = ft.Text(f"{prefs['daily_goal']} min", size=14, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY)

    def change_goal(delta: int):
        new_value = max(5, min(60, prefs["daily_goal"] + delta))
        prefs["daily_goal"] = new_value
        goal_text.value = f"{new_value} min"
        update_preference("daily_goal", new_value)
        page.update()

    def build_toggle_row(icon_name: str, title: str, subtitle: str, key: str) -> ft.Container:
        def on_toggle(e):
            prefs[key] = e.control.value
            update_preference(key, e.control.value)

        return ft.Container(
            padding=ft.Padding.symmetric(vertical=10),
            content=ft.Row(
                vertical_alignment=ft.CrossAxisAlignment.CENTER,
                controls=[
                    ft.Icon(getattr(ft.Icons, icon_name.upper()), size=20, color=colors.BLUE_ACCENT),
                    ft.Column(
                        expand=True,
                        spacing=1,
                        controls=[
                            ft.Text(title, size=14, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                            ft.Text(subtitle, size=11, color=colors.TEXT_SECONDARY),
                        ],
                    ),
                    ft.Switch(value=prefs[key], active_color=colors.BLUE_ACCENT, on_change=on_toggle),
                ],
            ),
        )

    def on_logout(e):
        print("Cerrar sesion presionado")

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
                        ft.Text("TU CUENTA", size=12, weight=ft.FontWeight.W_500, color=colors.BLUE_ACCENT),
                        ft.Text("Perfil", size=24, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                    ],
                ),
                ft.Container(
                    bgcolor=colors.BG_CARD,
                    border_radius=16,
                    padding=16,
                    content=ft.Row(
                        spacing=12,
                        vertical_alignment=ft.CrossAxisAlignment.CENTER,
                        controls=[
                            ft.Container(
                                width=48,
                                height=48,
                                border_radius=24,
                                bgcolor=colors.BLUE_ACCENT,
                                alignment=ft.Alignment.CENTER,
                                content=ft.Text("J", size=18, weight=ft.FontWeight.W_500, color=colors.BG_PAGE),
                            ),
                            ft.Column(
                                spacing=1,
                                controls=[
                                    ft.Text("Jair", size=15, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                                    ft.Text("Miembro desde agosto 2026", size=11, color=colors.TEXT_SECONDARY),
                                ],
                            ),
                        ],
                    ),
                ),
                ft.Container(
                    bgcolor=colors.BG_CARD,
                    border_radius=16,
                    padding=16,
                    content=ft.Column(
                        spacing=4,
                        controls=[
                            ft.Row(
                                alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                                vertical_alignment=ft.CrossAxisAlignment.CENTER,
                                controls=[
                                    ft.Column(
                                        spacing=1,
                                        controls=[
                                            ft.Text("Meta diaria", size=14, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                                            ft.Text("Minutos de practica", size=11, color=colors.TEXT_SECONDARY),
                                        ],
                                    ),
                                    ft.Row(
                                        spacing=8,
                                        controls=[
                                            ft.IconButton(
                                                icon=ft.Icons.REMOVE,
                                                icon_size=16,
                                                icon_color=colors.TEXT_SECONDARY,
                                                bgcolor=colors.BG_CARD_ICON,
                                                on_click=lambda e: change_goal(-5),
                                            ),
                                            goal_text,
                                            ft.IconButton(
                                                icon=ft.Icons.ADD,
                                                icon_size=16,
                                                icon_color=colors.TEXT_SECONDARY,
                                                bgcolor=colors.BG_CARD_ICON,
                                                on_click=lambda e: change_goal(5),
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                            ft.Divider(color=colors.BG_CARD_ICON, height=1),
                            build_toggle_row("notifications", "Recordatorios diarios", "8:00 p. m.", "reminders"),
                            build_toggle_row("music_note", "Sonidos suaves", "Guia auditiva en ejercicios", "sounds"),
                            build_toggle_row("chat_bubble_outline", "Compartir con terapeuta", "Enviar resumen semanal", "share_therapist"),
                        ],
                    ),
                ),
                ft.Container(
                    bgcolor=colors.BG_CARD,
                    border_radius=12,
                    padding=14,
                    alignment=ft.Alignment.CENTER,
                    on_click=on_logout,
                    content=ft.Text("Cerrar sesion", size=14, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY),
                ),
            ],
        ),
    )
