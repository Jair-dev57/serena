import asyncio
import flet as ft

from theme import colors

PROMPTS = [
    "Cual fue el mejor momento de tu semana?",
    "Describe un lugar donde te sientas en calma.",
    "Cuentame sobre algo que te gustaria aprender.",
]


def build_exercise_run_talk_screen(page: ft.Page, exercise, on_finish) -> ft.Container:
    state = {"prompt_index": 0, "seconds_elapsed": 0, "pulse": True, "running": True}

    prompt_text = ft.Text(PROMPTS[0], size=16, color=ft.Colors.WHITE, text_align=ft.TextAlign.CENTER)
    timer_text = ft.Text("Grabando... 0:00", size=13, color=colors.TEXT_SECONDARY)
    step_bars = ft.Row(spacing=4)
    outer_ring = ft.Container(width=120, height=120, border_radius=60, bgcolor="rgba(127,179,224,0.12)")
    mid_ring = ft.Container(width=90, height=90, border_radius=45, bgcolor="rgba(127,179,224,0.20)")
    mic_circle = ft.Container(
        width=64,
        height=64,
        border_radius=32,
        bgcolor=colors.BLUE_ACCENT,
        alignment=ft.Alignment.CENTER,
        content=ft.Icon(ft.Icons.MIC, size=26, color=colors.BG_PAGE),
    )

    def render_step_bars():
        step_bars.controls = [
            ft.Container(expand=True, height=4, border_radius=2, bgcolor=colors.GREEN_SUCCESS if i <= state["prompt_index"] else colors.BG_CARD_ICON)
            for i in range(len(PROMPTS))
        ]

    def format_time(seconds: int) -> str:
        return f"{seconds // 60}:{seconds % 60:02d}"

    def go_to_prompt(index: int):
        state["prompt_index"] = index
        state["seconds_elapsed"] = 0
        prompt_text.value = PROMPTS[index]
        timer_text.value = "Grabando... 0:00"
        render_step_bars()
        page.update()

    def advance():
        next_index = state["prompt_index"] + 1
        if next_index < len(PROMPTS):
            go_to_prompt(next_index)
            return True
        state["running"] = False
        on_finish(exercise)
        return False

    async def timer_loop():
        while state["running"]:
            await asyncio.sleep(1)
            if not state["running"]:
                continue
            state["seconds_elapsed"] += 1
            timer_text.value = f"Grabando... {format_time(state['seconds_elapsed'])}"
            state["pulse"] = not state["pulse"]
            outer_ring.bgcolor = "rgba(127,179,224,0.20)" if state["pulse"] else "rgba(127,179,224,0.12)"
            page.update()

    def on_skip_click(e):
        advance()

    def on_stop_click(e):
        advance()

    def on_close_click(e):
        state["running"] = False
        on_finish(None)

    render_step_bars()
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
                ft.Container(height=28),
                ft.Text(exercise.name.upper(), size=11, weight=ft.FontWeight.W_500, color=colors.BLUE_ACCENT, text_align=ft.TextAlign.CENTER),
                ft.Container(height=16),
                ft.Container(
                    bgcolor=colors.BG_CARD,
                    border_radius=16,
                    padding=18,
                    content=prompt_text,
                ),
                ft.Container(height=28),
                ft.Container(
                    alignment=ft.Alignment.CENTER,
                    content=ft.Stack(
                        controls=[
                            outer_ring,
                            ft.Container(
                                width=120,
                                height=120,
                                alignment=ft.Alignment.CENTER,
                                content=ft.Stack(controls=[mid_ring, ft.Container(width=90, height=90, alignment=ft.Alignment.CENTER, content=mic_circle)]),
                            ),
                        ],
                    ),
                ),
                ft.Container(height=16),
                ft.Row(alignment=ft.MainAxisAlignment.CENTER, controls=[timer_text]),
                ft.Container(expand=True),
                ft.Row(
                    spacing=10,
                    controls=[
                        ft.Container(
                            expand=True,
                            bgcolor=colors.BG_CARD,
                            border_radius=14,
                            padding=14,
                            alignment=ft.Alignment.CENTER,
                            on_click=on_skip_click,
                            content=ft.Text("Saltar", size=13, color=colors.TEXT_SECONDARY),
                        ),
                        ft.Container(
                            expand=True,
                            bgcolor=colors.RED_CHALLENGING,
                            border_radius=14,
                            padding=14,
                            alignment=ft.Alignment.CENTER,
                            on_click=on_stop_click,
                            content=ft.Text("Detener", size=13, weight=ft.FontWeight.W_500, color=ft.Colors.WHITE),
                        ),
                    ],
                ),
            ],
        ),
    )
