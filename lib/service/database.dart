import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseMethods {
  final SupabaseClient _client = Supabase.instance.client;

  // Menambahkan data mahasiswa ke Supabase
  Future<void> addStudent(Map<String, dynamic> studentInfoMap, String addID) async {
    final response = await _client
        .from('students')
        .insert({
          'id': addID,
          'nama': studentInfoMap['nama'],
          'nim': studentInfoMap['nim'],
          'semester': studentInfoMap['semester'],
        })
        .select(); // <- ini langsung men-trigger insert + ambil data

    if (response.isEmpty) {
      throw Exception('Insert failed or returned no data');
    }
  }

  // Mengambil data mahasiswa dari Supabase
  Future<List<Map<String, dynamic>>> getStudents() async {
    final response = await _client
        .from('students')
        .select(); // Mengambil data mahasiswa

    if (response.isEmpty) {
      return []; // Kembalikan list kosong jika tidak ada data
    } else {
      return List<Map<String, dynamic>>.from(response);
    }
  }
}
