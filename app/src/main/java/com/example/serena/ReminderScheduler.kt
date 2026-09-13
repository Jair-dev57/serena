package com.example.serena

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.example.serena.data.AppDatabase
import com.example.serena.data.PracticeSessionEntity
import java.util.Calendar

object ReminderScheduler {

    private const val REQUEST_CODE = 100

    private fun hasPracticedToday(sessions: List<PracticeSessionEntity>): Boolean {
        val today = Calendar.getInstance()
        today.set(Calendar.HOUR_OF_DAY, 0)
        today.set(Calendar.MINUTE, 0)
        today.set(Calendar.SECOND, 0)
        today.set(Calendar.MILLISECOND, 0)
        val todayStart = today.timeInMillis
        val todayEnd = todayStart + 24 * 60 * 60 * 1000L

        return sessions.any { it.completedAt in todayStart until todayEnd }
    }

    suspend fun scheduleNext(context: Context, hour: Int = 20, minute: Int = 0) {
        val db = AppDatabase.getInstance(context)
        val sessions = db.practiceSessionDao().getAll()

        val target = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }

        val now = Calendar.getInstance()
        val practicedToday = hasPracticedToday(sessions)

        if (practicedToday || target.before(now)) {
            target.add(Calendar.DAY_OF_YEAR, 1)
        }

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ReminderReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )

        try {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                target.timeInMillis,
                pendingIntent
            )
        } catch (e: SecurityException) {
            // El usuario no otorgo permiso de alarmas exactas, no hacemos nada
        }
    }

    fun cancel(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ReminderReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            REQUEST_CODE,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        alarmManager.cancel(pendingIntent)
    }
}