import 'package:flutter/material.dart';

class CalonPeserta extends StatefulWidget {
  const CalonPeserta({super.key});

  @override
  State<CalonPeserta> createState() => _CalonPesertaState();
}

class _CalonPesertaState extends State<CalonPeserta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Calon Peserta"),
      ),
    );
  }
}
