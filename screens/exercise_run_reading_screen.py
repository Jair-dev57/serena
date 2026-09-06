import asyncio
import flet as ft

from theme import colors

PHRASES = [
    "El cielo se pintaba de naranja mientras el sol se escondia despacio.",
    "Camine tranquilo por el parque, sintiendo el aire fresco en mi cara.",
    "Cada palabra que digo la practico con calma y sin apuro.",
    "Hoy elijo hablar despacio, dandome el tiempo que necesito.",
    "El agua del rio corria suave entre las piedras grises.",
    "Respire profundo antes de empezar a contar mi historia.",
]

SECONDS_PER_PHRASE = 6
BPM_SECONDS = 1.0


def build_exercise_run_reading_screen(page: ft.Page, exercise, on_finish) -> ft.Container:
    state = {"phrase_index": 0, "seconds_left": SECONDS_PER_PHRASE, "pulse": 0, "paused": False, "running": True}

    phrase_text = ft.Text(PHRASES[0], size=20, color=ft.Colors.WHITE, text_align=ft.TextAlign.CENTER)
    bpm_label = ft.Text("60 ppm", size=12, color=colors.TEXT_SECONDARY)
    step_bars = ft.Row(spacing=4)
    dots_row = ft.Row(spacing=8, alignment=ft.MainAxisAlignment.CENTER)
    pause_icon = ft.Icon(ft.Icons.PAUSE, color=colors.TEXT_SECONDARY, size=18)

    def render_step_bars():
        step_bars.controls = [
            ft.Container(expand=True, height=4, border_radius=2, bgcolor=colors.GREEN_SUCCESS if i <= state["phrase_index"] else colors.BG_CARD_ICON)
            for i in range(len(PHRASES))
        ]

    def render_dots():
        dots_row.controls = [
            ft.Container(width=10, height=10, border_radius=5, bgcolor=colors.BLUE_ACCENT if i == state["pulse"] else colors.BG_CARD_ICON)
            for i in range(3)
        ]

    def go_to_phrase(index: int):
        state["phrase_index"] = index
        state["seconds_left"] = SECONDS_PER_PHRASE
        phrase_text.value = PHRASES[index]
        render_step_bars()
        page.update()

    def advance():
        next_index = state["phrase_index"] + 1
        if next_index < len(PHRASES):
            go_to_phrase(next_index)
            return True
        state["running"] = False
        on_finish(exercise)
        return False

    async def timer_loop():
        while state["running"]:
            await asyncio.sleep(BPM_SECONDS)
            if state["paused"] or not state["running"]:
                continue
            state["pulse"] = (state["pulse"] + 1) % 3
            render_dots()
            state["seconds_left"] -= 1
            page.update()
            if state["seconds_left"] <= 0:
                advance()

    def on_pause_click(e):
        state["paused"] = not state["paused"]
        pause_icon.name = ft.Icons.PLAY_ARROW if state["paused"] else ft.Icons.PAUSE
        page.update()

    def on_skip_click(e):
        advance()

    def on_close_click(e):
        state["running"] = False
        on_finish(None)

    render_step_bars()
    render_dots()
    page.run_task(timer_loop)

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
                        ft.IconButton(icon=ft.Icons.CLOSE, icon_color=colors.TEXT_SECONDARY, on_click=on_close_click),
                        ft.Container(width=40),
                    ],
                ),
                step_bars,
                ft.Container(height=24),
                ft.Text(exercise.name.upper(), size=11, weight=ft.FontWeight.W_500, color=colors.BLUE_ACCENT, text_align=ft.TextAlign.CENTER),
                ft.Container(height=20),
                ft.Container(
                    bgcolor=colors.BG_CARD,
                    border_radius=16,
                    padding=ft.Padding.symmetric(horizontal=18, vertical=24),
                    alignment=ft.Alignment.CENTER,
                    content=phrase_text,
                ),
                ft.Container(height=20),
                dots_row,
                ft.Container(height=8),
                ft.Row(alignment=ft.MainAxisAlignment.CENTER, controls=[bpm_label]),
                ft.Container(expand=True),
                ft.Row(
                    spacing=10,
                    controls=[
                        ft.Container(bgcolor=colors.BG_CARD, border_radius=14, padding=14, alignment=ft.Alignment.CENTER, on_click=on_pause_click, content=pause_icon),
                        ft.Container(
                            expand=True,
                            bgcolor=colors.BLUE_ACCENT,
                            border_radius=14,
                            padding=14,
                            alignment=ft.Alignment.CENTER,
                            on_click=on_skip_click,
                            content=ft.Text("Siguiente frase", size=13, weight=ft.FontWeight.W_500, color=colors.BG_PAGE),
                        ),
                    ],
                ),
            ],
        ),
    )
