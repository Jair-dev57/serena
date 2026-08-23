import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class BlockEntryEndpoint extends Endpoint {
  Future<List<BlockEntry>> getAllEntries(Session session) async {
    return BlockEntry.db.find(
      session,
      orderBy: (t) => t.dateTime,
      orderDescending: true,
    );
  }

  Future<BlockEntry> createEntry(
    Session session,
    DateTime dateTime,
    BlockSeverity severity,
    BlockContext context,
    String? note,
  ) async {
    final newEntry = BlockEntry(
      dateTime: dateTime,
      severity: severity,
      context: context,
      note: note,
    );
    return BlockEntry.db.insertRow(session, newEntry);
  }

  Future<BlockEntry> updateEntry(Session session, BlockEntry entry) async {
    return BlockEntry.db.updateRow(session, entry);
  }

  Future<void> deleteEntry(Session session, int id) async {
    final existing = await BlockEntry.db.findById(session, id);
    if (existing != null) {
      await BlockEntry.db.deleteRow(session, existing);
    }
  }
}