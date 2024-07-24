import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppdb_spendap/pages/edit_formulir_pendaftaran_page.dart';
import 'package:ppdb_spendap/pages/formulir_pendaftaran_page.dart';
import 'package:ppdb_spendap/pages/pengumuman_pendaftaran_page.dart';
import 'package:ppdb_spendap/pages/upload_dokumen.dart';
import '/pages/login_page.dart';
import '/pages/register_page.dart';
import '/pages/reset_password_page.dart';
import '/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/reset_password': (context) => ResetPasswordPage(),
        '/home': (context) => HomePage(),
        '/formulirpendaftaran': (context) => FormulirPendaftaranPage(),
        '/editdatapendaftaran': (context) => EditFormulirPendaftaranPage(),
        '/pengumumanpendaftaran': (context) => PengumumanPendaftaranPage(),
        '/uploaddokumen': (context) => UploadDokumen(),
      },
    );
  }
}
