import 'package:flutter/material.dart';
import '../data/local_db.dart';
import '../models/exercise.dart';
import '../data/exercises_data.dart';
import 'exercise_detail_screen.dart';

enum WordSortOption { recent, oldest, alphabetical }

class DifficultWordsScreen extends StatefulWidget {
  const DifficultWordsScreen({super.key});

  @override
  State<DifficultWordsScreen> createState() => _DifficultWordsScreenState();
}

class _DifficultWordsScreenState extends State<DifficultWordsScreen> {
  List<DifficultWord> _words = [];
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  WordSortOption _sortOption = WordSortOption.recent;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWords() async {
    final words = await LocalDb.instance.getAllWords();
    setState(() {
      _words = words;
    });
  }

  Future<void> _addWord(String text, String? note) async {
    final word = DifficultWord(
      word: text,
      dateAdded: DateTime.now(),
      note: note,
    );
    await LocalDb.instance.insertWord(word);
    _loadWords();
  }

  Future<bool> _confirmDelete(DifficultWord word) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('¿Eliminar palabra?'),
          content: Text('¿Seguro que quieres eliminar "${word.word}"?'),
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

  void _handleDismiss(DifficultWord word) async {
    await LocalDb.instance.deleteWord(word.id!);
    _loadWords();
  }

  void _showEditDialog(DifficultWord word) {
    final wordController = TextEditingController(text: word.word);
    final noteController = TextEditingController(text: word.note ?? '');
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar palabra'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Palabra'),
              ),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: 'Nota (opcional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (wordController.text.trim().isNotEmpty) {
                  final noteText = noteController.text.trim();
                  final updated = DifficultWord(
                    id: word.id,
                    word: wordController.text.trim(),
                    dateAdded: word.dateAdded,
                    note: noteText.isEmpty ? null : noteText,
                  );
                  await LocalDb.instance.updateWord(updated);
                  _loadWords();
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog() {
    final wordController = TextEditingController();
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Agregar palabra difícil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: wordController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Ej: paralelepípedo'),
              ),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  hintText: 'Nota (opcional): ¿cuándo se te dificulta?',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (wordController.text.trim().isNotEmpty) {
                  final noteText = noteController.text.trim();
                  _addWord(
                    wordController.text.trim(),
                    noteText.isEmpty ? null : noteText,
                  );
                }
                Navigator.pop(dialogContext);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _showExercisePicker(DifficultWord word) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Practicar "${word.word}" con:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final exercise in exercises)
                ListTile(
                  title: Text(exercise.title),
                  subtitle: Text(exercise.category.label),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(exercise: exercise),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  List<DifficultWord> get _filteredWords {
    List<DifficultWord> result = _words;
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((w) => w.word.toLowerCase().contains(query)).toList();
    }

    final sorted = List<DifficultWord>.from(result);
    switch (_sortOption) {
      case WordSortOption.recent:
        sorted.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      case WordSortOption.oldest:
        sorted.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      case WordSortOption.alphabetical:
        sorted.sort((a, b) => a.word.toLowerCase().compareTo(b.word.toLowerCase()));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar palabra...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('Palabras difíciles'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          PopupMenuButton<WordSortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) {
              setState(() {
                _sortOption = option;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: WordSortOption.recent,
                child: Text('Más reciente'),
              ),
              PopupMenuItem(
                value: WordSortOption.oldest,
                child: Text('Más antiguo'),
              ),
              PopupMenuItem(
                value: WordSortOption.alphabetical,
                child: Text('Alfabético'),
              ),
            ],
          ),
        ],
      ),
      body: _filteredWords.isEmpty
          ? Center(
              child: Text(
                _searchQuery.isEmpty
                    ? 'Aún no has agregado palabras.'
                    : 'No se encontraron palabras.',
              ),
            )
          : ListView.builder(
              itemCount: _filteredWords.length,
              itemBuilder: (context, index) {
                final word = _filteredWords[index];
                return Dismissible(
                  key: ValueKey(word.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(word),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _handleDismiss(word),
                  child: ListTile(
                    title: Text(word.word),
                    subtitle: Text(
                      word.note != null && word.note!.isNotEmpty
                          ? '${word.dateAdded.day}/${word.dateAdded.month}/${word.dateAdded.year} · ${word.note}'
                          : '${word.dateAdded.day}/${word.dateAdded.month}/${word.dateAdded.year}',
                    ),
                    onTap: () => _showExercisePicker(word),
                    onLongPress: () => _showEditDialog(word),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}