// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import '../service/database.dart';

class AddStudent extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? studentData;

  const AddStudent({super.key, this.isEdit = false, this.studentData});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController(); // NIM
  final TextEditingController rollnoController = TextEditingController(); // Semester
  String attendanceStatus = 'H';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.studentData != null) {
      nameController.text = widget.studentData!['nama'] ?? '';
      ageController.text = widget.studentData!['nim'].toString();
      rollnoController.text = widget.studentData!['semester'] ?? '';
      attendanceStatus = widget.studentData!['absensi'] ?? 'H';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    rollnoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new_outlined),
                ),
                SizedBox(width: 80.0),
                Text(
                  "Data",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.0),
                Text(
                  "Mahasiswa",
                  style: TextStyle(color: Colors.blue, fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20.0),

            // Nama
            Text("Nama Mahasiswa", style: _labelStyle()),
            SizedBox(height: 10.0),
            _buildTextField(nameController, "Isi Nama"),

            // NIM
            SizedBox(height: 20.0),
            Text("NIM", style: _labelStyle()),
            SizedBox(height: 10.0),
            _buildTextField(ageController, "Isi NIM"),

            // Semester
            SizedBox(height: 20.0),
            Text("Semester", style: _labelStyle()),
            SizedBox(height: 10.0),
            _buildTextField(rollnoController, "Isi Semester"),

            // Attendance
            SizedBox(height: 20.0),
            Text("Absensi", style: _labelStyle()),
            SizedBox(height: 10.0),
            DropdownButton<String>(
              value: attendanceStatus,
              onChanged: (String? newValue) {
                setState(() {
                  attendanceStatus = newValue!;
                });
              },
              items: <String>['H', 'A'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value == 'H' ? 'Hadir' : 'Alpha'),
                );
              }).toList(),
            ),

            // Tombol Simpan
            SizedBox(height: 40.0),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty &&
                      rollnoController.text.isNotEmpty) {
                    setState(() => isLoading = true);

                    Map<String, dynamic> studentInfoMap = {
                      "nama": nameController.text,
                      "nim": ageController.text,
                      "semester": rollnoController.text,
                      "absensi": attendanceStatus,
                    };

                    try {
                      if (widget.isEdit && widget.studentData != null) {
                        await DatabaseMethods().updateStudent(widget.studentData!['id'], studentInfoMap);
                      } else {
                        String addID = randomAlphaNumeric(10);
                        await DatabaseMethods().addStudent(studentInfoMap, addID);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            widget.isEdit ? "Data Berhasil Diupdate!" : "Data Berhasil Disimpan!",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );

                      Navigator.pop(context); // kembali ke halaman sebelumnya
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Error: ${e.toString()}"),
                        ),
                      );
                    } finally {
                      setState(() => isLoading = false);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orange,
                        content: Text("Harap isi semua field!"),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.isEdit ? "Update" : "Add",
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold);
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10.0)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
