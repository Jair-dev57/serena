import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../data/local_db.dart';
import '../data/recording_manager.dart';
import '../models/exercise.dart';

class RecorderWidget extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;

  const RecorderWidget({
    super.key,
    required this.exerciseId,
    required this.exerciseTitle,
  });

  @override
  State<RecorderWidget> createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _lastRecordingPath;
  String? _previousRecordingPath;
  bool _sessionSaved = false;

  @override
  void initState() {
    super.initState();
    _loadPreviousRecording();
  }

  Future<void> _loadPreviousRecording() async {
    final path = await RecordingManager.getRecordingPath(widget.exerciseId);
    setState(() {
      _previousRecordingPath = path;
    });
  }

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
    if (path != null) {
      await RecordingManager.saveRecordingPath(widget.exerciseId, path);
    }
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

  Future<void> _playPath(String path) async {
    setState(() {
      _isPlaying = true;
    });
    await _player.play(DeviceFileSource(path));
    _player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
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
            onPressed: _isPlaying ? null : () => _playPath(_lastRecordingPath!),
            icon: const Icon(Icons.play_arrow),
            label: Text(_isPlaying ? 'Reproduciendo...' : 'Escuchar esta grabación'),
          ),
        ],
        if (_previousRecordingPath != null &&
            _previousRecordingPath != _lastRecordingPath) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _isPlaying ? null : () => _playPath(_previousRecordingPath!),
            icon: const Icon(Icons.history),
            label: const Text('Escuchar grabación anterior'),
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