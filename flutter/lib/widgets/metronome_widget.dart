import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MetronomeWidget extends StatefulWidget {
  final VoidCallback? onStarted;

  const MetronomeWidget({super.key, this.onStarted});

  @override
  State<MetronomeWidget> createState() => _MetronomeWidgetState();
}

class _MetronomeWidgetState extends State<MetronomeWidget> {
  Timer? _timer;
  bool _isPlaying = false;
  bool _pulseOn = false;
  int _bpm = 60;

  void _toggle() {
    if (_isPlaying) {
      _stop();
    } else {
      _start();
    }
  }

  void _start() {
    widget.onStarted?.call();
    final intervalMs = (60000 / _bpm).round();
    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      SystemSound.play(SystemSoundType.click);
      setState(() {
        _pulseOn = !_pulseOn;
      });
    });
    setState(() {
      _isPlaying = true;
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _pulseOn = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: _pulseOn ? 70 : 50,
          height: _pulseOn ? 70 : 50,
          decoration: BoxDecoration(
            color: _pulseOn ? Colors.deepPurple : Colors.deepPurple.shade100,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 12),
        Text('$_bpm BPM'),
        Slider(
          value: _bpm.toDouble(),
          min: 30,
          max: 120,
          onChanged: (value) {
            setState(() {
              _bpm = value.round();
            });
            if (_isPlaying) {
              _stop();
              _start();
            }
          },
        ),
        FilledButton.icon(
          onPressed: _toggle,
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          label: Text(_isPlaying ? 'Detener' : 'Iniciar metrónomo'),
        ),
      ],
    );
  }
}