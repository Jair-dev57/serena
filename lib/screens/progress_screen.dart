import 'package:flutter/material.dart';
import '../data/local_db.dart';
import '../models/exercise.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<PracticeSession> _sessions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await LocalDb.instance.getAllSessions();
    setState(() {
      _sessions = sessions;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi progreso')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? const Center(child: Text('Aún no has practicado ningún ejercicio.'))
              : ListView.builder(
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final session = _sessions[index];
                    return ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: Text(session.exerciseTitle),
                      subtitle: Text(session.date.toString()),
                    );
                  },
                ),
    );
  }
}