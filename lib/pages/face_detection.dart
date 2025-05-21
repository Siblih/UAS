// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({Key? key}) : super(key: key);

  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deteksi Wajah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            const Text(
              'Selamat datang di halaman Deteksi Wajah!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                // Tempatkan logika deteksi wajah di sini nanti
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur deteksi wajah belum tersedia')),
                );
              },
              icon: const Icon(Icons.face),
              label: const Text('Mulai Deteksi Wajah'),
            ),
            const SizedBox(height: 40.0),
            Expanded(
              child: Center(
                child: Text(
                  'Fitur Deteksi Wajah akan ditambahkan segera.',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
