import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class CalonPeserta extends StatefulWidget {
  const CalonPeserta({super.key});

  @override
  State<CalonPeserta> createState() => _CalonPesertaState();
}

class _CalonPesertaState extends State<CalonPeserta> {
  List<dynamic> _data = [];

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
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${response.statusCode}')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Sudah':
        return Colors.green;
      case 'Ditolak':
        return Colors.red;
      case 'Belum':
        return Colors.yellow;
      default:
        return Colors.grey; // Default color if status is unknown
    }
  }

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
        padding: EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 30.0,
                  columns: [
                    DataColumn(label: Center(child: Text('No'))),
                    DataColumn(label: Center(child: Text('Nama'))),
                    DataColumn(label: Center(child: Text('Ket.'))),
                  ],
                  rows: _data
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(cells: [
                          DataCell(
                              Text(" " + (entry.key + 1).toString() + " .")),
                          DataCell(Text(entry.value['name'])),
                          DataCell(
                            Text(
                              entry.value['status'],
                              style: TextStyle(
                                backgroundColor:
                                    _getStatusColor(entry.value['status']),
                              ),
                            ),
                          ),
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
