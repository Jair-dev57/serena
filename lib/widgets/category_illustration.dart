import 'package:flutter/material.dart';
import '../models/exercise.dart';

class CategoryIllustration extends StatefulWidget {
  final ExerciseCategory category;

  const CategoryIllustration({super.key, required this.category});

  @override
  State<CategoryIllustration> createState() => _CategoryIllustrationState();
}

class _CategoryIllustrationState extends State<CategoryIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _breathScale = Tween<double>(begin: 0.75, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _categoryColor(BuildContext context) {
    switch (widget.category) {
      case ExerciseCategory.respiracion:
        return const Color(0xFF6FB8A8);
      case ExerciseCategory.inicioSuave:
        return const Color(0xFF8FA8D8);
      case ExerciseCategory.ritmo:
        return const Color(0xFFD8A85B);
      case ExerciseCategory.lectura:
        return const Color(0xFFB88FC8);
    }
  }

  IconData _categoryIcon() {
    switch (widget.category) {
      case ExerciseCategory.respiracion:
        return Icons.air;
      case ExerciseCategory.inicioSuave:
        return Icons.graphic_eq;
      case ExerciseCategory.ritmo:
        return Icons.speed;
      case ExerciseCategory.lectura:
        return Icons.menu_book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(context);

    if (widget.category == ExerciseCategory.respiracion) {
      return AnimatedBuilder(
        animation: _breathScale,
        builder: (context, child) {
          return Column(
            children: [
              Transform.scale(
                scale: _breathScale.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.25),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(Icons.air, size: 40, color: color),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _breathScale.value > 0.95 ? 'Inhala' : 'Exhala',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
      ),
      child: Icon(_categoryIcon(), size: 44, color: color),
    );
  }
}