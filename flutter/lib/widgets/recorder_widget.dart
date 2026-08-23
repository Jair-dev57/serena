import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../data/local_db.dart';
import '../data/recording_manager.dart';
import '../models/exercise.dart';
import '../theme/app_styles.dart';
import '../data/server_client.dart';
class RecorderWidget extends StatefulWidget {
  final String exerciseId;
  final String exerciseTitle;
  final VoidCallback? onRecorded;
  final VoidCallback? onRecordingStarted;

  const RecorderWidget({
    super.key,
    required this.exerciseId,
    required this.exerciseTitle,
    this.onRecorded,
    this.onRecordingStarted,
  });

  @override
  State<RecorderWidget> createState() => _RecorderWidgetState();
}

class _RecorderWidgetState extends State<RecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _playingPath;
  bool _sessionSaved = false;
  bool _expanded = false;
  List<Recording> _recordings = [];

  static const int _collapsedCount = 2;

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    final recordings = await RecordingManager.getRecordings(widget.exerciseId);
    setState(() {
      _recordings = recordings;
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
    widget.onRecordingStarted?.call();
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
    });
    if (path != null) {
      await RecordingManager.addRecording(widget.exerciseId, path);
      await _loadRecordings();
    }
    await ServerClient.instance.practiceSession.insertSession(
      widget.exerciseTitle,
      DateTime.now(),
    );
    setState(() {
      _sessionSaved = true;
    });
    widget.onRecorded?.call();
  }

  Future<void> _playPath(String path) async {
    setState(() {
      _isPlaying = true;
      _playingPath = path;
    });
    await _player.play(DeviceFileSource(path));
    _player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playingPath = null;
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

  String _formatDateTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month} $hour:$minute';
  }

  Widget _buildRecordingTile(Recording recording, int index) {
    final isLatest = index == 0;
    final isPlayingThis = _isPlaying && _playingPath == recording.path;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isLatest
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outlineVariant,
          ),
          color: isLatest
              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
          borderRadius: BorderRadius.circular(AppStyles.barRadius),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: _isPlaying && !isPlayingThis ? null : () => _playPath(recording.path),
              customBorder: const CircleBorder(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLatest
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Icon(
                  isPlayingThis ? Icons.pause : Icons.play_arrow,
                  size: 18,
                  color: isLatest
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Repetición ${_recordings.length - index}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    isLatest ? 'Más reciente · ${_formatDateTime(recording.dateTime)}' : _formatDateTime(recording.dateTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hiddenCount = _recordings.length - _collapsedCount;
    final visibleRecordings = _expanded || hiddenCount <= 0
        ? _recordings
        : _recordings.take(_collapsedCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            icon: Icon(_isRecording ? Icons.stop : Icons.mic),
            label: Text(_isRecording ? 'Detener' : 'Grabar repetición ${_recordings.length + 1}'),
          ),
        ),
        if (visibleRecordings.isNotEmpty) ...[
          const SizedBox(height: 16),
          for (int i = 0; i < visibleRecordings.length; i++) _buildRecordingTile(visibleRecordings[i], i),
        ],
        if (hiddenCount > 0)
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              label: Text(_expanded ? 'Ver menos' : 'Ver $hiddenCount grabaciones más'),
            ),
          ),
        if (_sessionSaved)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '✓ Sesión guardada en tu progreso',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
      ],
    );
  }
}