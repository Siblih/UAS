import 'package:flutter/material.dart';
import 'package:project_uas/pages/add_student.dart'; // Sesuaikan path sesuai proyek Anda
import '../service/database.dart'; // Menambahkan referensi ke DatabaseMethods

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _students;

  @override
  void initState() {
    super.initState();
    _students = DatabaseMethods().getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudent()));
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Data",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.0),
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
            SizedBox(height: 30.0),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _students,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data mahasiswa.'));
                } else {
                  final students = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        var student = students[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 16.0),
                          child: Material(
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Nama Mahasiswa :",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 3.0),
                                      Expanded(
                                        child: Text(
                                          student['nama'] ?? "Tidak ada nama",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Text(
                                        "NIM :",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 3.0),
                                      Expanded(
                                        child: Text(
                                          (student['nim'] is int)
                                              ? student['nim'].toString()
                                              : student['nim'] ?? "Tidak ada NIM",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Text(
                                        "Semester :",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 3.0),
                                      Expanded(
                                        child: Text(
                                          student['semester'] ?? "Tidak ada semester",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Text(
                                        "Attendance :",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Container(
                                        width: 50,
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.green, borderRadius: BorderRadius.circular(10.0)),
                                        child: Center(
                                          child: Text(
                                            "H",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20.0),
                                      Container(
                                        width: 50,
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                            color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
                                        child: Center(
                                          child: Text(
                                            "A",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.orange),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddStudent(
                                                isEdit: true,
                                                studentData: student,
                                              ),
                                            ),
                                          );
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
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
