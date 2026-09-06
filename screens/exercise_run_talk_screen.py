import asyncio
import random
import flet as ft

from theme import colors

PROMPTS = [
    "Cual fue el mejor momento de tu semana?",
    "Describe un lugar donde te sientas en calma.",
    "Cuentame sobre algo que te gustaria aprender.",
]

WAVE_BAR_COUNT = 7
WAVE_MIN_HEIGHT = 6
WAVE_MAX_HEIGHT = 36
WAVE_TICK_SECONDS = 0.35


def build_exercise_run_talk_screen(page: ft.Page, exercise, on_finish) -> ft.Container:
    state = {"prompt_index": 0, "seconds_elapsed": 0, "running": True}

    prompt_text = ft.Text(PROMPTS[0], size=16, color=ft.Colors.WHITE, text_align=ft.TextAlign.CENTER)
    timer_text = ft.Text("Grabando... 0:00", size=13, color=colors.TEXT_SECONDARY)
    step_bars = ft.Row(spacing=4)

    mic_circle = ft.Container(
        width=64,
        height=64,
        border_radius=32,
        bgcolor=colors.BLUE_ACCENT,
        alignment=ft.Alignment.CENTER,
        content=ft.Icon(ft.Icons.MIC, size=26, color=colors.BG_PAGE),
    )

    wave_bars = []
    for _ in range(WAVE_BAR_COUNT):
        bar = ft.Container(
            width=6,
            height=WAVE_MIN_HEIGHT,
            border_radius=3,
            bgcolor=colors.BLUE_ACCENT,
            animate=ft.Animation(int(WAVE_TICK_SECONDS * 1000), ft.AnimationCurve.EASE_IN_OUT),
        )
        wave_bars.append(bar)

    def render_step_bars():
        step_bars.controls = [
            ft.Container(expand=True, height=4, border_radius=2, bgcolor=colors.GREEN_SUCCESS if i <= state["prompt_index"] else colors.BG_CARD_ICON)
            for i in range(len(PROMPTS))
        ]

    def format_time(seconds: int) -> str:
        return f"{seconds // 60}:{seconds % 60:02d}"

    def randomize_waves():
        for bar in wave_bars:
            bar.height = random.randint(WAVE_MIN_HEIGHT, WAVE_MAX_HEIGHT)

    def reset_waves():
        for bar in wave_bars:
            bar.height = WAVE_MIN_HEIGHT

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

    async def wave_loop():
        tick = 0
        while state["running"]:
            await asyncio.sleep(WAVE_TICK_SECONDS)
            if not state["running"]:
                continue
            randomize_waves()
            page.update()
            tick += 1
            if tick % 3 == 0:
                state["seconds_elapsed"] += 1
                timer_text.value = f"Grabando... {format_time(state['seconds_elapsed'])}"
                page.update()

    def on_skip_click(e):
        advance()

    def on_stop_click(e):
        advance()

    def on_close_click(e):
        state["running"] = False
        on_finish(None)

    render_step_bars()
    page.run_task(wave_loop)

    return ft.Container(
        expand=True,
        bgcolor=colors.BG_PAGE,
        padding=20,
        content=ft.Column(
            expand=True,
            spacing=0,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
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
                mic_circle,
                ft.Container(height=20),
                ft.Row(
                    alignment=ft.MainAxisAlignment.CENTER,
                    vertical_alignment=ft.CrossAxisAlignment.END,
                    spacing=5,
                    controls=wave_bars,
                ),
                ft.Container(height=12),
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
