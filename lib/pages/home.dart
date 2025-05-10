import 'package:flutter/material.dart';
import 'package:project_uas/pages/add_student.dart'; // Sesuaikan path sesuai proyek Anda
import '../service/database.dart'; // Menambahkan referensi ke DatabaseMethods

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Map<String, dynamic>>> _students; // Mendeklarasikan future untuk mengambil data mahasiswa

  @override
  void initState() {
    super.initState();
    _students = DatabaseMethods().getStudents(); // Mengambil data mahasiswa saat halaman dimuat
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
            // Header
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
            SizedBox(height: 30.0),
            // Mengambil dan menampilkan daftar mahasiswa
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _students, // Mengambil data mahasiswa
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // Menunggu data
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // Menampilkan error jika gagal
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data mahasiswa.')); // Menampilkan pesan jika data kosong
                } else {
                  final students = snapshot.data!; // Data mahasiswa yang diambil
                  return Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        var student = students[index];
                        return Container(
  margin: EdgeInsets.only(bottom: 16.0), // Jarak antar item
  child: Material(
    elevation: 3.0,
    borderRadius: BorderRadius.circular(10.0),
    child: Container(
      padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
      width: MediaQuery.of(context).size.width,
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
                                    SizedBox(width: 3.0), // Menambah jarak antar kolom
                                    Expanded(
                                      child: Text(
                                        student['nama'] ?? "Tidak ada nama", // Menangani null atau tidak ada data
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
                                    SizedBox(width: 3.0), // Menambah jarak antar kolom
                                    Expanded(
                                      child: Text(
                                        (student['nim'] is int)
                                            ? student['nim'].toString() // Konversi int ke String
                                            : student['nim'] ?? "Tidak ada NIM", // Menangani null atau kesalahan
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
                                    SizedBox(width: 3.0), // Menambah jarak antar kolom
                                    Expanded(
                                      child: Text(
                                        student['semester'] ?? "Tidak ada semester", // Menangani null atau tidak ada data
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
                                    SizedBox(width: 16.0), // Menambah jarak antar kolom
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
                                SizedBox(height: 10.0), // Menambah jarak antar row
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
