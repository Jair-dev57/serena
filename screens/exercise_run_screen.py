import asyncio
import flet as ft

from theme import colors

BREATHING_CYCLES = 4
PHASES = [
    ("Inhala", 4, "Inhala lento por la nariz"),
    ("Sosten", 7, "Manten el aire en tus pulmones, relaja los hombros"),
    ("Exhala", 8, "Suelta el aire despacio por la boca"),
]


def build_exercise_run_screen(page: ft.Page, exercise, on_finish) -> ft.Container:
    state = {"cycle": 0, "phase_index": 0, "seconds_left": PHASES[0][1], "paused": False, "running": True}

    phase_label = ft.Text(PHASES[0][0], size=19, weight=ft.FontWeight.W_500, color=ft.Colors.WHITE, text_align=ft.TextAlign.CENTER)
    instruction_text = ft.Text(PHASES[0][2], size=13, color=colors.TEXT_SECONDARY, text_align=ft.TextAlign.CENTER)
    seconds_text = ft.Text(str(PHASES[0][1]), size=32, weight=ft.FontWeight.W_300, color=ft.Colors.WHITE)
    progress_ring = ft.ProgressRing(value=1.0, width=150, height=150, stroke_width=8, color=colors.BLUE_ACCENT, bgcolor=colors.BG_CARD_ICON)
    step_bars = ft.Row(spacing=4)
    pause_icon = ft.Icon(ft.Icons.PAUSE, color=colors.TEXT_SECONDARY, size=18)

    def render_step_bars():
        step_bars.controls = [
            ft.Container(expand=True, height=4, border_radius=2, bgcolor=colors.GREEN_SUCCESS if i < state["cycle"] else colors.BG_CARD_ICON)
            for i in range(BREATHING_CYCLES)
        ]

    def go_to_phase(cycle: int, phase_index: int):
        state["cycle"] = cycle
        state["phase_index"] = phase_index
        name, duration, instruction = PHASES[phase_index]
        state["seconds_left"] = duration
        phase_label.value = name
        instruction_text.value = instruction
        seconds_text.value = str(duration)
        progress_ring.value = 1.0
        render_step_bars()
        page.update()

    def advance():
        next_phase = state["phase_index"] + 1
        if next_phase < len(PHASES):
            go_to_phase(state["cycle"], next_phase)
            return True
        next_cycle = state["cycle"] + 1
        if next_cycle < BREATHING_CYCLES:
            go_to_phase(next_cycle, 0)
            return True
        state["running"] = False
        on_finish(exercise)
        return False

    async def timer_loop():
        while state["running"]:
            await asyncio.sleep(1)
            if state["paused"] or not state["running"]:
                continue
            state["seconds_left"] -= 1
            _, duration, _ = PHASES[state["phase_index"]]
            progress_ring.value = max(0.0, state["seconds_left"] / duration)
            seconds_text.value = str(max(0, state["seconds_left"]))
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
                ft.Container(height=6),
                phase_label,
                ft.Container(height=28),
                ft.Container(
                    alignment=ft.Alignment.CENTER,
                    content=ft.Stack(
                        controls=[
                            progress_ring,
                            ft.Container(
                                width=150,
                                height=150,
                                alignment=ft.Alignment.CENTER,
                                content=ft.Column(
                                    horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                                    spacing=0,
                                    controls=[seconds_text, ft.Text("segundos", size=11, color=colors.TEXT_SECONDARY)],
                                ),
                            ),
                        ],
                    ),
                ),
                ft.Container(height=24),
                instruction_text,
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
                            content=ft.Text("Siguiente paso", size=13, weight=ft.FontWeight.W_500, color=colors.BG_PAGE),
                        ),
                    ],
                ),
            ],
        ),
    )
