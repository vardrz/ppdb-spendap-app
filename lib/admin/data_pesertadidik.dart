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
        title: Text("Data Peserta Didik"),
      ),
    );
  }
}
