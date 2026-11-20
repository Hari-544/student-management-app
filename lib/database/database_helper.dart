// lib/database/database_helper.dart
// Singleton facade for platform-specific student storage.

import '../models/student.dart';
import 'database_backend_native.dart'
    if (dart.library.html) 'database_backend_web.dart' as backend;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal() : _database = backend.createStudentDatabase();

  final backend.StudentDatabase _database;

  Future<int> insertStudent(Student student) async {
    return _database.insertStudent(student);
  }

  Future<List<Student>> getAllStudents() async {
    return _database.getAllStudents();
  }

  Future<List<Student>> searchStudents(String query) async {
    return _database.searchStudents(query);
  }

  Future<int> updateStudent(Student student) async {
    return _database.updateStudent(student);
  }

  Future<int> deleteStudent(int id) async {
    return _database.deleteStudent(id);
  }

  Future<int> getTotalCount() async {
    return _database.getTotalCount();
  }
}
