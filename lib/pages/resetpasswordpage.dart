// import yang diperlukan
// ignore_for_file: use_super_parameters, use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final supabase = Supabase.instance.client;

  bool _isLoading = false;

  Future<void> _updatePassword() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      _showMessage('Password tidak boleh kosong', isError: true);
      return;
    }

    if (password != confirm) {
      _showMessage('Password tidak cocok', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await supabase.auth.updateUser(UserAttributes(password: password));
      _showMessage('Password berhasil diperbarui', isError: false);
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showMessage('Gagal memperbarui password: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reset Password"),
        backgroundColor: const Color.fromRGBO(49, 39, 79, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 300,
                    width: width,
                    child: FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: 300,
                    width: width + 20,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Container(
                        decoration: const BoxDecoration(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: const Text(
                      "Buat Password Baru",
                      style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1700),
                    child: const Text(
                      "Masukkan password baru kamu di bawah ini",
                      style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, .6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Column(
                      children: [
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password Baru",
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _confirmController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Konfirmasi Password",
                            hintStyle: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: MaterialButton(
                      onPressed: _isLoading ? null : _updatePassword,
                      color: const Color.fromRGBO(49, 39, 79, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 50,
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Reset Password", style: TextStyle(color: Colors.white)),
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
}
