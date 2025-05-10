import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseMethods {
  final SupabaseClient _client = Supabase.instance.client;

  // Tambah mahasiswa
  Future<void> addStudent(Map<String, dynamic> studentInfoMap, String addID) async {
    final response = await _client
        .from('students')
        .insert({
          'id': addID,
          'nama': studentInfoMap['nama'],
          'nim': studentInfoMap['nim'],
          'semester': studentInfoMap['semester'],
          'attendance': studentInfoMap['attendance'],
        })
        .select();

    if (response.isEmpty) {
      throw Exception('Insert failed or returned no data');
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
        })
        .eq('id', id)
        .select();

    if (response.isEmpty) {
      throw Exception('Update failed or returned no data');
    }
  }

  // Hapus mahasiswa
  Future<void> deleteStudent(String id) async {
    await _client
        .from('students')
        .delete()
        .eq('id', id);
  }

  // Ambil semua mahasiswa
  Future<List<Map<String, dynamic>>> getStudents() async {
    final response = await _client
        .from('students')
        .select();

    if (response.isEmpty) {
      return [];
    } else {
      return List<Map<String, dynamic>>.from(response);
    }
  }
}
