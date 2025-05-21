import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/home.dart';
import 'pages/forgotpasswordpage.dart';
import 'pages/resetpasswordpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal lokal Indonesia
  await initializeDateFormatting('id_ID', null);

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: "https://mbrvmrtmlmdpoiavlmsh.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1icnZtcnRtbG1kcG9pYXZsbXNoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcwMjE4NzEsImV4cCI6MjA2MjU5Nzg3MX0.DgN2aSobKxOnF1osPqeuedCFGx6A8H_TVfoJjt8IF_g",
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await _checkLoginStatus();
    await _checkInitialLink();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> _checkInitialLink() async {
    final uri = await getInitialUri();
    if (uri != null && uri.queryParameters.containsKey('code')) {
      final code = uri.queryParameters['code'];
      final supabase = Supabase.instance.client;

      await supabase.auth.exchangeCodeForSession(code!);

      // Simpan status login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Navigasi ke halaman reset password
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/reset-password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Absenku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _isLoggedIn ? const Home() : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const Home(),
        '/forgot-password': (context) => const ForgotPasswordPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
      },
    );
  }
}
