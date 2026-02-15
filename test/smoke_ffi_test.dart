import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('simple ffi test', () async {
    final db = await openDatabase(inMemoryDatabasePath);
    await db.execute('CREATE TABLE test (id INTEGER PRIMARY KEY)');
    await db.insert('test', {'id': 1});
    final results = await db.query('test');
    expect(results.length, 1);
    await db.close();
  });
}
