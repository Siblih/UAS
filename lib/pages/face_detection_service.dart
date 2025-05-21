import 'package:flutter/material.dart';
import '../service/api_service.dart';

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  bool _isProcessing = false;
  String _resultMessage = '';

  final ApiService api = ApiService();

  // Simulasi deteksi wajah - nanti ganti dengan hasil dari face recognition model
  Future<String?> _simulateFaceDetection() async {
    await Future.delayed(const Duration(seconds: 2));
    return '12345678'; // contoh NIM hasil deteksi wajah
  }

  Future<void> _handleFaceDetection() async {
    setState(() {
      _isProcessing = true;
      _resultMessage = '';
    });

    final nim = await _simulateFaceDetection();

    if (nim == null) {
      setState(() {
        _isProcessing = false;
        _resultMessage = 'Gagal mendeteksi wajah.';
      });
      return;
    }

    try {
      final student = await api.getStudentByNim(nim);

      if (student != null) {
        await api.markAttendance(student, 'H');
        setState(() {
          _resultMessage = 'Absensi berhasil dicatat untuk NIM $nim.';
        });
      } else {
        setState(() {
          _resultMessage = 'Mahasiswa dengan NIM $nim tidak ditemukan.';
        });
      }
    } catch (e) {
      setState(() {
        _resultMessage = 'Terjadi kesalahan: $e';
      });
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Wajah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: _isProcessing
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Tekan tombol di bawah untuk memulai deteksi wajah.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.face),
                      label: const Text('Deteksi Wajah'),
                      onPressed: _handleFaceDetection,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _resultMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: _resultMessage.contains('berhasil')
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
