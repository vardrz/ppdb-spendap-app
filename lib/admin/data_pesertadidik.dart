import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class DataPesertadidik extends StatefulWidget {
  const DataPesertadidik({super.key});

  @override
  State<DataPesertadidik> createState() => _DataPesertadidikState();
}

class _DataPesertadidikState extends State<DataPesertadidik> {
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
          "Data Peserta Didik Baru",
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
                "Tabel Peserta Didik Baru",
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
                    DataColumn(label: Center(child: Text('NIK'))),
                    DataColumn(label: Center(child: Text('Nama'))),
                  ],
                  rows: _filteredData
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(cells: [
                          DataCell(
                              Text(" " + (entry.key + 1).toString() + " .")),
                          DataCell(Text(entry.value['nik'])),
                          DataCell(Text(entry.value['name'])),
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
