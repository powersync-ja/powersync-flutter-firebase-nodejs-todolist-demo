import '../powersync.dart';
import 'package:powersync/sqlite3.dart' as sqlite;

class TodoItem {
  final String id;
  final String description;
  final bool completed;

  TodoItem(
      {required this.id, required this.description, required this.completed});

  factory TodoItem.fromRow(sqlite.Row row) {
    return TodoItem(
        id: row['id'],
        description: row['description'],
        completed: row['completed'] == 1);
  }

  Future<void> toggle() async {
    if (completed) {
      await db.execute(
          'UPDATE todos SET completed = FALSE, completed_by = NULL, completed_at = NULL WHERE id = ?',
          [id]);
    } else {
      await db.execute(
          'UPDATE todos SET completed = TRUE, completed_by = ?, completed_at = datetime() WHERE id = ?',
          [getUserId(), id]);
    }
  }

  Future<void> delete() async {
    await db.execute('DELETE FROM todos WHERE id = ?', [id]);
  }
}