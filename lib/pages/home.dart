import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/pages/add_student.dart';
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
      });
    }
  }

  String _formatShortDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    String shortDate = _formatShortDate(_selectedDate);

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
      // Judul "Data Mahasiswa"
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Data ",
            style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
          ),
          Text(
            "Mahasiswa",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      SizedBox(height: 40.0),
      Center(
        child: Column(
          children: [
            Text(
              _formatter.format(_selectedDate),
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: Icon(Icons.calendar_today),
              label: Text("Pilih Tanggal"),
            ),
          ],
        ),
      ),
     
      
      // (lanjutkan ke FutureBuilder seperti sebelumnya...)

            
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _students,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: \${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data mahasiswa.'));
                } else {
                  final students = snapshot.data!
                      .where((student) => student['absensi_tanggal'] == shortDate)
                      .toList();

                  if (students.isEmpty) {
                    return Expanded(child: Center(child: Text("Tidak ada data pada tanggal ini.")));
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        var student = students[index];
                        String attendance = student['absensi'] ?? 'A';

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
                                      Text("Nama Mahasiswa :",
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
                                      Text("NIM :",
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
                                      Text("Semester :",
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
                                      Text("Absensi :",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      for (var absen in ['H', 'A', 'I'])
                                        Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: Container(
                                            width: 50,
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                              color: attendance == absen
                                                  ? (absen == 'H'
                                                      ? Colors.green
                                                      : absen == 'A'
                                                          ? Colors.red
                                                          : Color.fromARGB(255, 228, 244, 54))
                                                  : Colors.grey,
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                absen,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
