import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../data/local_db.dart';
import '../models/exercise.dart';

class RecorderWidget extends StatefulWidget {
  final String exerciseTitle;

  const RecorderWidget({super.key, required this.exerciseTitle});

  @override
  State<RecorderWidget> createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _lastRecordingPath;
  bool _sessionSaved = false;

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/practica_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(const RecordConfig(), path: path);

    setState(() {
      _isRecording = true;
      _sessionSaved = false;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _lastRecordingPath = path;
    });

    await LocalDb.instance.insertSession(
      PracticeSession(
        exerciseTitle: widget.exerciseTitle,
        date: DateTime.now(),
      ),
    );

    setState(() {
      _sessionSaved = true;
    });
  }

  Future<void> _playRecording() async {
    if (_lastRecordingPath == null) return;

    setState(() {
      _isPlaying = true;
    });

    await _player.play(DeviceFileSource(_lastRecordingPath!));

    _player.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: _isRecording ? _stopRecording : _startRecording,
          icon: Icon(_isRecording ? Icons.stop : Icons.mic),
          label: Text(_isRecording ? 'Detener' : 'Grabar'),
        ),
        if (_lastRecordingPath != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _isPlaying ? null : _playRecording,
            icon: const Icon(Icons.play_arrow),
            label: Text(_isPlaying ? 'Reproduciendo...' : 'Escuchar'),
          ),
        ],
        if (_sessionSaved) ...[
          const SizedBox(height: 8),
          const Text('✓ Sesión guardada en tu progreso'),
        ],
      ],
    );
  }
}