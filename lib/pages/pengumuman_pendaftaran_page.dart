import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class PengumumanPendaftaranPage extends StatefulWidget {
  const PengumumanPendaftaranPage({super.key});

  @override
  State<PengumumanPendaftaranPage> createState() => _DataPesertadidikState();
}

class _DataPesertadidikState extends State<PengumumanPendaftaranPage> {
  List<dynamic> _data = [];
  List<dynamic> _filteredData = [];

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
        _filteredData =
            _data.where((item) => item['status'] == 'Sudah').toList();
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${response.statusCode}')),
      );
    }
  }

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
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Peserta Didik Tahun 2024/2025",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700]),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 30.0,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.green[100]!),
                  columns: [
                    DataColumn(
                        label: Center(
                            child: Text(
                      'Nomor',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                    DataColumn(
                        label: Center(
                            child: Text(
                      'Nama',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                    DataColumn(
                        label: Center(
                            child: Text(
                      'Asal Sekolah',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                  ],
                  rows: _filteredData
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(cells: [
                          DataCell(Center(
                              child: Text((entry.key + 1).toString() + " ."))),
                          DataCell(Text(entry.value['name'])),
                          DataCell(Text(entry.value['school'])),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
