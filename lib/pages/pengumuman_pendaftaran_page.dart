import 'package:flutter/material.dart';

class PengumumanPendaftaranPage extends StatefulWidget {
  const PengumumanPendaftaranPage({super.key});

  @override
  State<PengumumanPendaftaranPage> createState() =>
      _PengumumanPendaftaranPageState();
}

class _PengumumanPendaftaranPageState extends State<PengumumanPendaftaranPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        centerTitle: true,
        title: Text(
          "Pengumuman Pendaftaran",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
            padding: EdgeInsets.all(15.0),
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ]),
            child: Column(
              children: [
                Text("Daftar Siswa Yang Lolos Pendaftaran Peserta Didik Baru")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
