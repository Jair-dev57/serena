import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class DifficultWordEndpoint extends Endpoint {
  Future<List<DifficultWord>> getAllWords(Session session) async {
    return DifficultWord.db.find(
      session,
      orderBy: (t) => t.dateAdded,
      orderDescending: true,
    );
  }

  Future<DifficultWord> createWord(
    Session session,
    String word,
    String? note,
  ) async {
    final newWord = DifficultWord(
      word: word,
      dateAdded: DateTime.now(),
      note: note,
    );
    return DifficultWord.db.insertRow(session, newWord);
  }

  Future<DifficultWord> updateWord(Session session, DifficultWord word) async {
    return DifficultWord.db.updateRow(session, word);
  }

  Future<void> deleteWord(Session session, int id) async {
    final existing = await DifficultWord.db.findById(session, id);
    if (existing != null) {
      await DifficultWord.db.deleteRow(session, existing);
    }
  }
}