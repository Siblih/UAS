// ignore_for_file: use_build_context_synchronously, sort_child_properties_last, unused_import, avoid_returning_null_for_void

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/pages/add_student.dart';
import 'package:project_uas/pages/face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../service/database.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _students;
  DateTime _selectedDate = DateTime.now();
  final DateFormat _formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

  @override
  void initState() {
    super.initState();
    _students = DatabaseMethods().getStudents();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _students = DatabaseMethods().getStudents();
      });
    }
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> uploadPhotoFromGallery(String nim) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final fileExt = pickedFile.path.split('.').last;
if (!['jpg', 'jpeg', 'png'].contains(fileExt.toLowerCase())) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Format file tidak didukung.')));
  return;
}

final fileBytes = await pickedFile.readAsBytes();
final fileName = '$nim.$fileExt';
final storagePath = 'photos/$fileName';


      final supabase = Supabase.instance.client;

      await supabase.storage
          .from('student-photos')
          .uploadBinary(storagePath, fileBytes, fileOptions: FileOptions(upsert: true));
await supabase
        .from('mahasiswa')
        .update({'foto': fileName})
        .eq('nim', nim);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Foto berhasil diunggah.')));
      setState(() {
        _students = DatabaseMethods().getStudents();
      });
    }
  }

  String getPhotoUrl(String? fotoFileName) {
    if (fotoFileName == null || fotoFileName.isEmpty) return '';
    final supabase = Supabase.instance.client;
    return supabase.storage.from('student-photos').getPublicUrl('photos/$fotoFileName');
  }


  @override
  Widget build(BuildContext context) {
    String shortDate = _formatShortDate(_selectedDate);

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Data ", style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold)),
                Text("Mahasiswa", style: TextStyle(color: Colors.blue, fontSize: 26.0, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 40.0),
            Center(
              child: Column(
                children: [
                  Text(_formatter.format(_selectedDate), style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: Icon(Icons.calendar_today),
                    label: Text("Pilih Tanggal"),
                  ),
                  SizedBox(height: 12.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FaceDetectionPage()));
                    },
                    icon: Icon(Icons.face),
                    label: Text("Deteksi Wajah"),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _students,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('Tidak ada data mahasiswa.'));

                final students = snapshot.data!
                    .where((student) => student['absensi_tanggal'] == shortDate)
                    .toList();

                if (students.isEmpty) return Expanded(child: Center(child: Text("Tidak ada data pada tanggal ini.")));

                return Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      var student = students[index];
                      String attendance = student['absensi'] ?? 'A';
                      String nim = student['nim'].toString();
                      String imageUrl = getPhotoUrl(student['foto']);


                      return Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.blue.shade50, Colors.white]),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6.0, offset: Offset(0, 3))],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
  backgroundColor: Colors.blue.shade200,
  radius: 25,
  backgroundImage: NetworkImage(imageUrl),
  onBackgroundImageError: (_, __) => null,
  child: Icon(Icons.person, color: Colors.white),
),

                                  SizedBox(width: 12.0),
                                  Expanded(
                                    child: Text(
                                      student['nama'] ?? "Tidak ada nama",
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.camera_alt, color: Colors.blue),
                                    onPressed: () => uploadPhotoFromGallery(nim),
                                  )
                                ],
                              ),
                              Divider(height: 20.0, color: Colors.blue.shade100),
                              Row(
                                children: [
                                  Text("NIM: ", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                                  Flexible(child: Text(nim, style: TextStyle(fontSize: 16.0))),
                                ],
                              ),
                              SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Text("Semester: ", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                                  Flexible(child: Text(student['semester'] ?? "-", style: TextStyle(fontSize: 16.0))),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                children: [
                                  Text("Absensi:", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 12.0),
                                  for (var absen in ['H', 'A', 'I'])
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        width: 50,
                                        padding: EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: attendance == absen
                                              ? (absen == 'H' ? Colors.green : absen == 'A' ? Colors.red : Colors.yellow.shade700)
                                              : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(absen, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 12.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddStudent(isEdit: true, studentData: student),
                                        ),
                                      );
                                      if (result == true) {
                                        setState(() {
                                          _students = DatabaseMethods().getStudents();
                                        });
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await DatabaseMethods().deleteStudent(student['id']);
                                      setState(() {
                                        _students = DatabaseMethods().getStudents();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              heroTag: "logout",
              backgroundColor: Colors.red,
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: "add",
              backgroundColor: Colors.blue,
              onPressed: () async {
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudent()));
                if (result == true) {
                  setState(() {
                    _students = DatabaseMethods().getStudents();
                  });
                }
              },
              child: Icon(Icons.add, color: Colors.white),
              tooltip: 'Tambah Mahasiswa',
            ),
          ),
        ],
      ),
    );
  }
}
