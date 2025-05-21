import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ApiService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Mendapatkan data mahasiswa berdasarkan NIM
  Future<Map<String, dynamic>?> getStudentByNim(String nim) async {
    final response = await _client
        .from('students')
        .select()
        .eq('nim', nim)
        .maybeSingle();

    return response;
  }

  /// Mengecek apakah mahasiswa sudah melakukan absensi pada tanggal tertentu
  Future<Map<String, dynamic>?> checkAbsence(String nim, String date) async {
    final response = await _client
        .from('students')
        .select()
        .eq('nim', nim)
        .eq('absensi_tanggal', date)
        .maybeSingle();

    return response;
  }

  /// Menandai absensi mahasiswa (update jika sudah ada, insert jika belum)
  Future<void> markAttendance(Map<String, dynamic> student, String status) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final existing = await checkAbsence(student['nim'], today);

    if (existing != null) {
      // Update absensi yang sudah ada
      await _client
          .from('students')
          .update({'absensi': status})
          .eq('id', existing['id']);
    } else {
      // Tambah data absensi baru
      await _client.from('students').insert({
        'nama': student['nama'],
        'nim': student['nim'],
        'semester': student['semester'],
        'absensi': status,
        'absensi_tanggal': today,
      });
    }
  }
}
