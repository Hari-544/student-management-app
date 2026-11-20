import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/student.dart';

StudentDatabase createStudentDatabase() => _WebStudentDatabase();

class StudentDatabase {
  Future<int> insertStudent(Student student) => throw UnimplementedError();
  Future<List<Student>> getAllStudents() => throw UnimplementedError();
  Future<List<Student>> searchStudents(String query) =>
      throw UnimplementedError();
  Future<int> updateStudent(Student student) => throw UnimplementedError();
  Future<int> deleteStudent(int id) => throw UnimplementedError();
  Future<int> getTotalCount() => throw UnimplementedError();
}

class _WebStudentDatabase extends StudentDatabase {
  static const _storageKey = 'student_management_app.students';
  late final Future<SharedPreferences> _preferences = _initialize();

  Future<SharedPreferences> _initialize() => SharedPreferences.getInstance();

  Future<List<Student>> _readStudents() async {
    final preferences = await _preferences;
    final encoded = preferences.getString(_storageKey);
    if (encoded == null) return [];

    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Stored student data is not a list.');
    }

    return decoded.map((item) {
      if (item is! Map) {
        throw const FormatException('Stored student data is invalid.');
      }
      return Student.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<void> _writeStudents(List<Student> students) async {
    final preferences = await _preferences;
    final saved = await preferences.setString(
      _storageKey,
      jsonEncode(students.map((student) => student.toMap()).toList()),
    );
    if (!saved) {
      throw StateError('The browser did not persist student data.');
    }
  }

  @override
  Future<int> insertStudent(Student student) async {
    final students = await _readStudents();
    if (students.any((item) => item.rollNumber == student.rollNumber)) {
      return -1;
    }
    final nextId = students.fold<int>(
          0,
          (maxId, item) =>
              item.id != null && item.id! > maxId ? item.id! : maxId,
        ) +
        1;
    students.add(student.copyWith(id: nextId));
    await _writeStudents(students);
    return nextId;
  }

  @override
  Future<List<Student>> getAllStudents() async {
    final students = await _readStudents();
    students.sort((a, b) => a.fullName.compareTo(b.fullName));
    return students;
  }

  @override
  Future<List<Student>> searchStudents(String query) async {
    final normalizedQuery = query.toLowerCase();
    final students = await _readStudents();
    final matches = students.where((student) {
      return student.fullName.toLowerCase().contains(normalizedQuery) ||
          student.rollNumber.toLowerCase().contains(normalizedQuery) ||
          student.course.toLowerCase().contains(normalizedQuery);
    }).toList();
    matches.sort((a, b) => a.fullName.compareTo(b.fullName));
    return matches;
  }

  @override
  Future<int> updateStudent(Student student) async {
    final students = await _readStudents();
    if (students.any(
      (item) => item.id != student.id && item.rollNumber == student.rollNumber,
    )) {
      return -1;
    }
    final index = students.indexWhere((item) => item.id == student.id);
    if (index == -1) return 0;
    students[index] = student;
    await _writeStudents(students);
    return 1;
  }

  @override
  Future<int> deleteStudent(int id) async {
    final students = await _readStudents();
    final originalLength = students.length;
    students.removeWhere((student) => student.id == id);
    if (students.length == originalLength) return 0;
    await _writeStudents(students);
    return 1;
  }

  @override
  Future<int> getTotalCount() async => (await _readStudents()).length;
}
