import 'package:flutter/material.dart';
import '../models/exercise.dart';

class AppStyles {
  static const double cardRadius = 16;
  static const double barRadius = 8;
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets screenPadding = EdgeInsets.all(16);

  static Color severityColor(BlockSeverity severity) {
    switch (severity) {
      case BlockSeverity.leve:
        return Colors.green;
      case BlockSeverity.moderado:
        return Colors.amber.shade700;
      case BlockSeverity.fuerte:
        return Colors.red;
    }
  }

  static Color rankColor(ExerciseRank rank) {
    switch (rank) {
      case ExerciseRank.cobre:
        return const Color(0xFFB87333);
      case ExerciseRank.plata:
        return const Color(0xFFC0C0C8);
      case ExerciseRank.oro:
        return const Color(0xFFE6B325);
      case ExerciseRank.platino:
        return const Color(0xFF6FA8DC);
      case ExerciseRank.diamante:
        return const Color(0xFF4FD9E8);
    }
  }

  static ShapeBorder cardShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius));
  }
}