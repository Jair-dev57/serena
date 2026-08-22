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

  static ShapeBorder cardShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius));
  }
}