import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PengumumanPendaftaranPage extends StatefulWidget {
  const PengumumanPendaftaranPage({super.key});

  @override
  State<PengumumanPendaftaranPage> createState() =>
      _PengumumanPendaftaranPageState();
}

class _PengumumanPendaftaranPageState extends State<PengumumanPendaftaranPage> {
  List<dynamic> students = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final String apiUrl = "https://ppdbspendap.agsa.site/api/formulir/get.php";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        setState(() {
          students = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isError
              ? Center(child: Text('Gagal memuat data, coba lagi nanti'))
              : SingleChildScrollView(
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
                          Text(
                            "Daftar Siswa Yang Lolos Pendaftaran Peserta Didik Baru",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(students[index]['name']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Asal Sekolah: ${students[index]['school']}"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
