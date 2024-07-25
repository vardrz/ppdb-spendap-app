import 'package:flutter/material.dart';

class VerifikasiPage extends StatefulWidget {
  const VerifikasiPage({super.key});

  @override
  State<VerifikasiPage> createState() => _VerifikasiPageState();
}

class _VerifikasiPageState extends State<VerifikasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verifikasi Data Peserta"),
      ),
    );
  }
}
