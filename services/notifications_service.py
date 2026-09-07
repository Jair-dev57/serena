from datetime import datetime, timedelta

from services.db_service import has_practiced_today

try:
    from flet_android_notifications import FletAndroidNotifications
    _notifications = FletAndroidNotifications()
except Exception:
    _notifications = None

REMINDER_ID = 1
REMINDER_TITLE = "Hora de practicar"
REMINDER_BODY = "Unos minutos de practica hoy te acercan a hablar con mas calma."


async def request_permissions() -> bool:
    if _notifications is None:
        return False
    try:
        return await _notifications.request_permissions()
    except Exception:
        return False


def _next_reminder_datetime(hour: int, minute: int) -> datetime:
    now = datetime.now()
    today_target = now.replace(hour=hour, minute=minute, second=0, microsecond=0)

    if has_practiced_today() or now >= today_target:
        return today_target + timedelta(days=1)
    return today_target


async def schedule_next_reminder(hour: int = 20, minute: int = 0) -> None:
    if _notifications is None:
        return
    target = _next_reminder_datetime(hour, minute)
    try:
        await _notifications.cancel_notification(REMINDER_ID)
        await _notifications.schedule_notification(
            notification_id=REMINDER_ID,
            title=REMINDER_TITLE,
            body=REMINDER_BODY,
            scheduled_time=target,
            repeats_daily=False,
        )
    except Exception as e:
        print(f"No se pudo programar el recordatorio: {e}")


async def cancel_daily_reminder() -> None:
    if _notifications is None:
        return
    try:
        await _notifications.cancel_notification(REMINDER_ID)
    except Exception as e:
        print(f"No se pudo cancelar el recordatorio: {e}")
