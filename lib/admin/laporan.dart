import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class Laporan extends StatefulWidget {
  const Laporan({super.key});

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  List<dynamic> _data = [];
  int totalPendaftar = 0;
  int diterima = 0;
  int ditolak = 0;
  int belumDiverifikasi = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String random = getRandomString(5);

    final response = await http.get(Uri.parse(
        'https://ppdbspendap.agsa.site/api/formulir/get.php?$random'));

    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body);
        totalPendaftar = _data.length;
        diterima = _data.where((item) => item['status'] == 'Sudah').length;
        ditolak = _data.where((item) => item['status'] == 'Ditolak').length;
        belumDiverifikasi =
            _data.where((item) => item['status'] == 'Belum').length;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${response.statusCode}')),
      );
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Laporan Peserta Didik Baru 2024/2025',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Pendaftar: $totalPendaftar'),
              pw.SizedBox(height: 10),
              pw.Text('Diterima: $diterima'),
              pw.SizedBox(height: 10),
              pw.Text('Ditolak: $ditolak'),
              pw.SizedBox(height: 10),
              pw.Text('Belum Diverifikasi: $belumDiverifikasi'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        centerTitle: true,
        title: const Text(
          "Laporan",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[350],
                  child: const Text(
                    "Laporan Peserta Didik Baru 2024/2025",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text("Pendaftar: $totalPendaftar"),
                const SizedBox(height: 10.0),
                Text("Diterima: $diterima"),
                const SizedBox(height: 10.0),
                Text("Ditolak: $ditolak"),
                const SizedBox(height: 10.0),
                Text("Belum Diverifikasi: $belumDiverifikasi"),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Printing.layoutPdf(onLayout: _generatePdf);
                  },
                  child: const Text(
                    "Cetak PDF",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
