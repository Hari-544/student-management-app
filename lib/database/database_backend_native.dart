import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/student.dart';

StudentDatabase createStudentDatabase() => _NativeStudentDatabase();

class StudentDatabase {
  Future<int> insertStudent(Student student) => throw UnimplementedError();
  Future<List<Student>> getAllStudents() => throw UnimplementedError();
  Future<List<Student>> searchStudents(String query) =>
      throw UnimplementedError();
  Future<int> updateStudent(Student student) => throw UnimplementedError();
  Future<int> deleteStudent(int id) => throw UnimplementedError();
  Future<int> getTotalCount() => throw UnimplementedError();
}

class _NativeStudentDatabase extends StudentDatabase {
  static const _tableName = 'students';
  static const _colId = 'id';
  static const _colRollNumber = 'roll_number';
  static const _colFullName = 'full_name';
  static const _colAge = 'age';
  static const _colGender = 'gender';
  static const _colCourse = 'course';
  static const _colEmail = 'email';
  static const _colPhone = 'phone';

  Future<Database>? _databaseFuture;

  Future<Database> get _database => _databaseFuture ??= _initializeDatabase();

  Future<Database> _initializeDatabase() async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'students.db'),
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE $_tableName (
          $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colRollNumber TEXT NOT NULL UNIQUE,
          $_colFullName TEXT NOT NULL,
          $_colAge INTEGER NOT NULL,
          $_colGender TEXT NOT NULL,
          $_colCourse TEXT NOT NULL,
          $_colEmail TEXT NOT NULL,
          $_colPhone TEXT NOT NULL
        )
      '''),
    );
  }

  @override
  Future<int> insertStudent(Student student) async {
    final db = await _database;
    final existing = await db.query(
      _tableName,
      where: '$_colRollNumber = ?',
      whereArgs: [student.rollNumber],
    );
    if (existing.isNotEmpty) return -1;
    return db.insert(
      _tableName,
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  @override
  Future<List<Student>> getAllStudents() async {
    final rows = await (await _database).query(
      _tableName,
      orderBy: _colFullName,
    );
    return rows.map(Student.fromMap).toList();
  }

  @override
  Future<List<Student>> searchStudents(String query) async {
    final like = '%$query%';
    final rows = await (await _database).query(
      _tableName,
      where:
          '$_colFullName LIKE ? OR $_colRollNumber LIKE ? OR $_colCourse LIKE ?',
      whereArgs: [like, like, like],
      orderBy: _colFullName,
    );
    return rows.map(Student.fromMap).toList();
  }

  @override
  Future<int> updateStudent(Student student) async {
    final db = await _database;
    final existing = await db.query(
      _tableName,
      where: '$_colRollNumber = ? AND $_colId != ?',
      whereArgs: [student.rollNumber, student.id],
    );
    if (existing.isNotEmpty) return -1;
    return db.update(
      _tableName,
      student.toMap(),
      where: '$_colId = ?',
      whereArgs: [student.id],
    );
  }

  @override
  Future<int> deleteStudent(int id) async {
    return (await _database).delete(
      _tableName,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> getTotalCount() async {
    final result = await (await _database).rawQuery(
      'SELECT COUNT(*) as count FROM $_tableName',
    );
    return (result.first['count'] as int?) ?? 0;
  }
}
