import 'package:flutter/material.dart';
import '../data/local_db.dart';
import '../models/exercise.dart';

class BlockDiaryScreen extends StatefulWidget {
  const BlockDiaryScreen({super.key});

  @override
  State<BlockDiaryScreen> createState() => _BlockDiaryScreenState();
}

class _BlockDiaryScreenState extends State<BlockDiaryScreen> {
  List<BlockEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await LocalDb.instance.getAllBlockEntries();
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _addEntry(BlockSeverity severity, BlockContext context, String? note) async {
    final entry = BlockEntry(
      dateTime: DateTime.now(),
      severity: severity,
      context: context,
      note: note,
    );
    await LocalDb.instance.insertBlockEntry(entry);
    _loadEntries();
  }

  Future<void> _deleteEntry(int id) async {
    await LocalDb.instance.deleteBlockEntry(id);
    _loadEntries();
  }

  void _showAddSheet() {
    BlockSeverity selectedSeverity = BlockSeverity.leve;
    BlockContext selectedContext = BlockContext.llamada;
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nuevo bloqueo', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    const Text('Severidad'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: BlockSeverity.values.map((severity) {
                        return ChoiceChip(
                          label: Text(severity.label),
                          selected: selectedSeverity == severity,
                          onSelected: (_) {
                            setSheetState(() {
                              selectedSeverity = severity;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Contexto'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BlockContext.values.map((ctx) {
                        return ChoiceChip(
                          label: Text(ctx.label),
                          selected: selectedContext == ctx,
                          onSelected: (_) {
                            setSheetState(() {
                              selectedContext = ctx;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        hintText: 'Nota (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final noteText = noteController.text.trim();
                          _addEntry(
                            selectedSeverity,
                            selectedContext,
                            noteText.isEmpty ? null : noteText,
                          );
                          Navigator.pop(bottomSheetContext);
                        },
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diario de bloqueos')),
      body: _entries.isEmpty
          ? const Center(child: Text('Aún no has registrado bloqueos.'))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteEntry(entry.id!),
                  child: ListTile(
                    title: Text('${entry.severity.label} · ${entry.context.label}'),
                    subtitle: Text(
                      entry.note != null && entry.note!.isNotEmpty
                          ? '${entry.dateTime.day}/${entry.dateTime.month}/${entry.dateTime.year} · ${entry.note}'
                          : '${entry.dateTime.day}/${entry.dateTime.month}/${entry.dateTime.year}',
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}