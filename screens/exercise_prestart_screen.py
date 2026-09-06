import flet as ft

from theme import colors


def build_exercise_prestart_screen(page: ft.Page, exercise, options: dict, default_label: str, on_start, on_close) -> ft.Container:
    state = {"selected": default_label if default_label in options else next(iter(options))}

    options_column = ft.Column(spacing=10)

    def render_options():
        rows = []
        for label, count in options.items():
            is_selected = label == state["selected"]

            def on_click(e, label=label):
                state["selected"] = label
                render_options()
                page.update()

            rows.append(
                ft.Container(
                    bgcolor=colors.BG_CARD_ICON if is_selected else colors.BG_CARD,
                    border=ft.Border.all(1.5, colors.BLUE_ACCENT if is_selected else colors.BG_CARD_ICON),
                    border_radius=12,
                    padding=14,
                    on_click=on_click,
                    content=ft.Row(
                        alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                        controls=[
                            ft.Text(label, size=14, weight=ft.FontWeight.W_500 if is_selected else ft.FontWeight.NORMAL, color=colors.TEXT_PRIMARY),
                            ft.Text(f"{count} rondas", size=12, color=colors.BLUE_ACCENT if is_selected else colors.TEXT_SECONDARY),
                        ],
                    ),
                )
            )
        options_column.controls = rows

    def on_start_click(e):
        on_start(state["selected"], options[state["selected"]])

    render_options()

    return ft.Container(
        expand=True,
        bgcolor=colors.BG_PAGE,
        padding=20,
        content=ft.Column(
            expand=True,
            spacing=0,
            controls=[
                ft.Row(
                    alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                    controls=[
                        ft.IconButton(icon=ft.Icons.CLOSE, icon_color=colors.TEXT_SECONDARY, on_click=lambda e: on_close()),
                        ft.Container(width=40),
                    ],
                ),
                ft.Container(height=24),
                ft.Text(exercise.name.upper(), size=11, weight=ft.FontWeight.W_500, color=colors.BLUE_ACCENT, text_align=ft.TextAlign.CENTER),
                ft.Container(height=6),
                ft.Text("Cuanto tiempo tenes?", size=19, weight=ft.FontWeight.W_500, color=colors.TEXT_PRIMARY, text_align=ft.TextAlign.CENTER),
                ft.Container(height=28),
                options_column,
                ft.Container(expand=True),
                ft.Container(
                    bgcolor=colors.BLUE_ACCENT,
                    border_radius=14,
                    padding=14,
                    alignment=ft.Alignment.CENTER,
                    on_click=on_start_click,
                    content=ft.Text("Comenzar", size=13, weight=ft.FontWeight.W_500, color=colors.BG_PAGE),
                ),
            ],
        ),
    )
