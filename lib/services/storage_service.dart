import '../models/chat_log.dart';
import 'database_service.dart';

class StorageService {
  final DatabaseService _db;

  StorageService(this._db);

  Future<void> saveLog(ChatLog log) async {
    await _db.saveLog(log);
  }

  Future<List<ChatLog>> getLogs() async {
    return await _db.getLogs();
  }
}