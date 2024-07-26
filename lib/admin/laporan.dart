import 'package:flutter/material.dart';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        centerTitle: true,
        title: Text(
          "Laporan",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
              child: Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Warna bayangan
                    spreadRadius: 2, // Radius penyebaran bayangan
                    blurRadius: 2, // Radius blur bayangan
                    offset: Offset(1, 1), // Offset bayangan (x, y)
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Container(
                    color: Colors.grey[350],
                    child: Text("Laporan Peserta Didik Baru 2024/2025")),
                SizedBox(
                  height: 10.0,
                ),
                Text("Pendaftar :"),
                SizedBox(
                  height: 10.0,
                ),
                Text("Diterima :"),
                SizedBox(
                  height: 10.0,
                ),
                Text("Ditolak :"),
                SizedBox(
                  height: 10.0,
                ),
                Text("Belum Diverifikasi :"),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
