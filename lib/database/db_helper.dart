import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/bill_record.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'electricity_bills.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bills(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            month TEXT NOT NULL,
            unitUsed REAL NOT NULL,
            totalCharges REAL NOT NULL,
            rebatePercent REAL NOT NULL,
            finalCost REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertBill(BillRecord record) async {
    final db = await database;
    return await db.insert('bills', record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<BillRecord>> getAllBills() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('bills', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => BillRecord.fromMap(maps[i]));
  }

  Future<BillRecord?> getBillById(int id) async {
    final db = await database;
    final maps = await db.query('bills', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return BillRecord.fromMap(maps.first);
    return null;
  }

  Future<int> updateBill(BillRecord record) async {
    final db = await database;
    return await db.update('bills', record.toMap(),
        where: 'id = ?', whereArgs: [record.id]);
  }

  Future<int> deleteBill(int id) async {
    final db = await database;
    return await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  }
}