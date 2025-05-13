import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseMethods {
  final SupabaseClient _client = Supabase.instance.client;

  // Tambah user
  Future<void> addUser(String username, String hashedPassword) async {
    final response = await _client.from('users').insert({
      'username': username,
      'password': hashedPassword,
    }).select();

    if (response.error != null) {
      throw Exception('Gagal menambahkan user: ${response.error!.message}');
    }
  }

  // Tambah mahasiswa
  Future<void> addStudent(Map<String, dynamic> studentInfoMap, String addID) async {
    final response = await _client
        .from('students')
        .insert({
          'id': addID,
          'nama': studentInfoMap['nama'],
          'nim': studentInfoMap['nim'],
          'semester': studentInfoMap['semester'],
          'absensi': studentInfoMap['absensi'],
          'absensi_tanggal': studentInfoMap['absensi_tanggal'],
        })
        .select();

    if (response.isEmpty) {
      throw Exception('Insert mahasiswa gagal');
    }
  }

  // Update mahasiswa
  Future<void> updateStudent(String id, Map<String, dynamic> studentData) async {
    final response = await _client
        .from('students')
        .update({
          'nama': studentData['nama'],
          'nim': studentData['nim'],
          'semester': studentData['semester'],
          'absensi': studentData['absensi'],
          'absensi_tanggal': studentData['absensi_tanggal'],
        })
        .eq('id', id)
        .select();

    if (response.isEmpty) {
      throw Exception('Update mahasiswa gagal');
    }
  }

  // Hapus mahasiswa
  Future<void> deleteStudent(String id) async {
    await _client.from('students').delete().eq('id', id);
  }

  // Ambil semua mahasiswa
  Future<List<Map<String, dynamic>>> getStudents() async {
    final response = await _client.from('students').select();

    if (response.isEmpty) {
      return [];
    } else {
      return List<Map<String, dynamic>>.from(response);
    }
  }

  // Update absensi
  Future<void> updateStudentAttendance(String id, String attendanceDate, String attendanceStatus) async {
    final response = await _client
        .from('students')
        .update({
          'absensi_tanggal': attendanceDate,
          'absensi': attendanceStatus,
        })
        .eq('id', id)
        .select();

    if (response.isEmpty) {
      throw Exception('Gagal update absensi');
    }
  }
}

extension on PostgrestList {
  get error => null;
}
