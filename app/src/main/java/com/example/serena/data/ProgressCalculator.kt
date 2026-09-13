package com.example.serena.data

import java.util.Calendar
import kotlin.random.Random

object ProgressCalculator {

    private fun startOfDay(timestamp: Long): Long {
        val cal = Calendar.getInstance()
        cal.timeInMillis = timestamp
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        cal.set(Calendar.MILLISECOND, 0)
        return cal.timeInMillis
    }

    fun getStreakDays(sessions: List<PracticeSessionEntity>): Int {
        if (sessions.isEmpty()) return 0
        val practicedDays = sessions.map { startOfDay(it.completedAt) }.toSet()

        var streak = 0
        var currentDay = startOfDay(System.currentTimeMillis())
        val oneDayMillis = 24 * 60 * 60 * 1000L

        while (practicedDays.contains(currentDay)) {
            streak += 1
            currentDay -= oneDayMillis
        }
        return streak
    }

    fun getMinutesThisWeek(sessions: List<PracticeSessionEntity>): Int {
        val cal = Calendar.getInstance()
        cal.set(Calendar.DAY_OF_WEEK, cal.firstDayOfWeek)
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        cal.set(Calendar.MILLISECOND, 0)
        val weekStart = cal.timeInMillis

        return sessions.filter { it.completedAt >= weekStart }.sumOf { it.durationMinutes }
    }

    fun getMinutesPerDayLast7(sessions: List<PracticeSessionEntity>): List<Pair<String, Int>> {
        val dayLabels = listOf("D", "L", "M", "X", "J", "V", "S")
        val result = mutableListOf<Pair<String, Int>>()

        for (i in 6 downTo 0) {
            val cal = Calendar.getInstance()
            cal.add(Calendar.DAY_OF_YEAR, -i)
            val dayStart = startOfDay(cal.timeInMillis)
            val dayEnd = dayStart + 24 * 60 * 60 * 1000L
            val total = sessions.filter { it.completedAt in dayStart until dayEnd }.sumOf { it.durationMinutes }
            val label = dayLabels[cal.get(Calendar.DAY_OF_WEEK) - 1]
            result.add(label to total)
        }
        return result
    }

    fun getRecentFluencyScores(sessions: List<PracticeSessionEntity>, n: Int = 6): List<Int> {
        val scores = sessions.takeLast(n).map { it.fluencyScore }
        return if (scores.isEmpty()) listOf(60) else scores
    }

    fun getAverageFluency(sessions: List<PracticeSessionEntity>): Int {
        val scores = getRecentFluencyScores(sessions, 10)
        return scores.average().toInt()
    }

    fun randomFluencyScore(): Int = Random.nextInt(65, 93)
}