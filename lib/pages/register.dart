// ignore_for_file: unnecessary_null_comparison, use_super_parameters, use_build_context_synchronously, avoid_print, sized_box_for_whitespace

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../service/database.dart'; // Import class DatabaseMethods

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final DatabaseMethods _dbMethods = DatabaseMethods();

  Future<void> _handleRegister() async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text;
  final confirmPassword = _confirmPasswordController.text;

  if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    _showSnackbar('Semua kolom harus diisi', Colors.red);
    return;
  }

  if (password != confirmPassword) {
    _showSnackbar('Password tidak cocok', Colors.red);
    return;
  }

  final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

  try {
    // Periksa apakah username sudah ada
    final existingUserResponse = await Supabase.instance.client
        .from('users')
        .select()
        .eq('username', username)
        .maybeSingle();// Mengambil satu baris
    
    if (existingUserResponse != null) {
      _showSnackbar('Username sudah digunakan', Colors.red);
      return;
    }

    // Jika tidak ada user yang sudah ada, lanjutkan untuk menambahkan user baru
    await _dbMethods.addUser(username, hashedPassword);

    _showSnackbar('Pendaftaran berhasil!', Colors.green);
    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print('Error saat mendaftar: $e');
    _showSnackbar('Terjadi kesalahan saat mendaftar.', Colors.red);
  }
}

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Background
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeInUp(
                      duration: Duration(seconds: 1),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background-2.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                 
                 
FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Form fields
                  FadeInUp(
                    duration: Duration(milliseconds: 1700),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Color.fromRGBO(196, 135, 198, .3)),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          _buildTextField(_usernameController, "Username"),
                          _buildTextField(_passwordController, "Password", obscure: true),
                          _buildTextField(_confirmPasswordController, "Confirm Password", obscure: true),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Already have an account? Login",
                            style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6))),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 1900),
                    child: MaterialButton(
                      onPressed: _handleRegister,
                      color: Color.fromRGBO(49, 39, 79, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 50,
                      child: Center(
                        child: Text("Register", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),

                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool obscure = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromRGBO(196, 135, 198, .3)),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}
