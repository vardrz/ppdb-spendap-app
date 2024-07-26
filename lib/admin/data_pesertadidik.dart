import 'package:flutter/material.dart';

class DataPesertadidik extends StatefulWidget {
  const DataPesertadidik({super.key});

  @override
  State<DataPesertadidik> createState() => _DataPesertadidikState();
}

class _DataPesertadidikState extends State<DataPesertadidik> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        centerTitle: true,
        title: Text(
          "Data Peserta Didik Baru",
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
                "Peserta Didik Tahun 2024/2025",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                "Tabel Peserta Didik Baru Yang Telah Diverifikasi",
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
