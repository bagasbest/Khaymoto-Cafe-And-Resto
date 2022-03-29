import 'package:cafe_and_resto/screens/homepage/homepage_screen.dart';
import 'package:cafe_and_resto/screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// main program untuk memulai aplikasi
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    /// cek apakah pengguna sudah login sebelumnya atau belum, jika sudah langsung masuk ke homepage, jika belum masuk ke login
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: HomePage(),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Poppins',
        ),
        home: LoginPage(),
      );
    }
  }
}