// ignore_for_file: unused_import, use_super_parameters, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({Key? key}) : super(key: key);

  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isProcessing = false;
  String _resultText = 'Belum ada hasil deteksi.';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[1], ResolutionPreset.medium);
    await _controller?.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _captureAndDetectFace() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isProcessing = true);

    final XFile imageFile = await _controller!.takePicture();
    final File file = File(imageFile.path);

    final uri = Uri.parse('http://<YOUR_SERVER_IP>:5000/detect'); // Ganti dengan IP server kamu

    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      setState(() {
        _resultText = result;
        _isProcessing = false;
      });
    } else {
      setState(() {
        _resultText = 'Deteksi gagal. Kode: ${response.statusCode}';
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deteksi Wajah')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_controller?.value.isInitialized ?? false)
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              )
            else
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _captureAndDetectFace,
              icon: const Icon(Icons.face),
              label: const Text('Mulai Deteksi Wajah'),
            ),
            const SizedBox(height: 24),
            if (_isProcessing) const CircularProgressIndicator(),
            Text(_resultText),
          ],
        ),
      ),
    );
  }
}
