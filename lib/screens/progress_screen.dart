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
  int _streak = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sessions = await LocalDb.instance.getAllSessions();
    final streak = await LocalDb.instance.getCurrentStreak();
    setState(() {
      _sessions = sessions;
      _streak = streak;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi progreso')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: ListTile(
                    leading: const Icon(Icons.local_fire_department, color: Colors.orange),
                    title: Text('Racha actual: $_streak días'),
                  ),
                ),
                Expanded(
                  child: _sessions.isEmpty
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
                ),
              ],
            ),
    );
  }
}