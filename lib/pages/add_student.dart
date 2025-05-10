// ignore_for_file: use_build_context_synchronously

import 'package:random_string/random_string.dart';
import '../service/database.dart'; // Adjust the path based on the actual location of database_methods.dart
import 'package:flutter/material.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  bool isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // kembali ke halaman sebelumnya
                  },
                  child: const Icon(Icons.arrow_back_ios_new_outlined),
                ),
                SizedBox(width: 80.0),
                Text(
                  "Data",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  "Mahasiswa",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              "Nama Mahasiswa",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10.0)),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Isi Nama "),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "NIM",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10.0)),
              child: TextField(
                controller: ageController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Isi NIM"),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Semester",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10.0)),
              child: TextField(
                controller: rollnoController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: "Isi Semester"),
              ),
            ),
            SizedBox(height: 50.0),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (nameController.text.isNotEmpty &&
                      ageController.text.isNotEmpty &&
                      rollnoController.text.isNotEmpty) {
                    String addID = randomAlphaNumeric(10);

                    Map<String, dynamic> studentInfoMap = {
                      "nama": nameController.text,
                      "nim": ageController.text,
                      "semester": rollnoController.text,
                    };

                    setState(() {
                      isLoading = true; // Show loading
                    });

                    try {
                      await DatabaseMethods().addStudent(studentInfoMap, addID);

                      // Clear fields after submission
                      nameController.clear();
                      ageController.clear();
                      rollnoController.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Data Berhasil Di Simpan!",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "Error: ${e.toString()}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    } finally {
                      setState(() {
                        isLoading = false; // Hide loading
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orange,
                        content: Text(
                          "Please fill in all fields!",
                          style: TextStyle(fontSize: 16.0),
                        ),
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
                        ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                        : Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
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
}
