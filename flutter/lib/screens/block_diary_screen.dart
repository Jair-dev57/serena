import 'package:flutter/material.dart';
import 'package:serena_client/serena_client.dart'
    show BlockEntry, BlockSeverity, BlockContext;
import '../data/server_client.dart';
import 'block_stats_screen.dart';
import '../models/block_labels.dart';

class BlockDiaryScreen extends StatefulWidget {
  const BlockDiaryScreen({super.key});

  @override
  State<BlockDiaryScreen> createState() => _BlockDiaryScreenState();
}

class _BlockDiaryScreenState extends State<BlockDiaryScreen> {
  List<BlockEntry> _entries = [];
  BlockSeverity? _filterSeverity;
  BlockContext? _filterContext;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final entries = await ServerClient.instance.blockEntry.getAllEntries();
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _addEntry(BlockSeverity severity, BlockContext context, String? note) async {
    await ServerClient.instance.blockEntry.createEntry(
      DateTime.now(),
      severity,
      context,
      note,
    );
    _loadEntries();
  }

  Future<bool> _confirmDelete(BlockEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('¿Eliminar registro?'),
          content: Text(
            '¿Seguro que quieres eliminar este bloqueo (${entry.severity.label} · ${entry.context.label})?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  Future<void> _deleteEntry(int id) async {
    await ServerClient.instance.blockEntry.deleteEntry(id);
    _loadEntries();
  }

  void _showEditSheet(BlockEntry entry) {
    BlockSeverity selectedSeverity = entry.severity;
    BlockContext selectedContext = entry.context;
    final noteController = TextEditingController(text: entry.note ?? '');

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
                    Text('Editar bloqueo', style: Theme.of(context).textTheme.titleLarge),
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
                        onPressed: () async {
                          final noteText = noteController.text.trim();
                          final updated = entry.copyWith(
                            severity: selectedSeverity,
                            context: selectedContext,
                            note: noteText.isEmpty ? null : noteText,
                          );
                          await ServerClient.instance.blockEntry.updateEntry(updated);
                          _loadEntries();
                          if (bottomSheetContext.mounted) {
                            Navigator.pop(bottomSheetContext);
                          }
                        },
                        child: const Text('Guardar cambios'),
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

  void _showFilterSheet() {
    BlockSeverity? tempSeverity = _filterSeverity;
    BlockContext? tempContext = _filterContext;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtrar', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  const Text('Severidad'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: BlockSeverity.values.map((severity) {
                      return ChoiceChip(
                        label: Text(severity.label),
                        selected: tempSeverity == severity,
                        onSelected: (selected) {
                          setSheetState(() {
                            tempSeverity = selected ? severity : null;
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
                        selected: tempContext == ctx,
                        onSelected: (selected) {
                          setSheetState(() {
                            tempContext = selected ? ctx : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            setSheetState(() {
                              tempSeverity = null;
                              tempContext = null;
                            });
                          },
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _filterSeverity = tempSeverity;
                              _filterContext = tempContext;
                            });
                            Navigator.pop(bottomSheetContext);
                          },
                          child: const Text('Aplicar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<BlockEntry> get _filteredEntries {
    return _entries.where((e) {
      final matchesSeverity = _filterSeverity == null || e.severity == _filterSeverity;
      final matchesContext = _filterContext == null || e.context == _filterContext;
      return matchesSeverity && matchesContext;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diario de bloqueos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlockStatsScreen(entries: _entries),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _filterSeverity != null || _filterContext != null
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
            ),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: _filteredEntries.isEmpty
          ? const Center(child: Text('Aún no has registrado bloqueos.'))
          : ListView.builder(
              itemCount: _filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = _filteredEntries[index];
                return Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(entry),
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
                    onLongPress: () => _showEditSheet(entry),
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