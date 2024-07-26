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
        backgroundColor: Colors.green[700],
        centerTitle: true,
        title: Text(
          "Data Calon Peserta",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Data Calon Peserta Didik Tahun 2024/2025",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                "Tabel Calon Peserta Didik Baru",
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
