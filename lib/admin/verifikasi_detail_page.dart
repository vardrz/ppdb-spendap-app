import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class VerifikasiDetailPage extends StatefulWidget {
  final String email;

  const VerifikasiDetailPage({Key? key, required this.email}) : super(key: key);

  @override
  _VerifikasiDetailPageState createState() => _VerifikasiDetailPageState();
}

class _VerifikasiDetailPageState extends State<VerifikasiDetailPage> {
  Map<String, dynamic>? _data;

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
        'https://ppdbspendap.agsa.site/api/formulir/get.php?$random=&email=${widget.email}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.isNotEmpty) {
        setState(() {
          _data = jsonResponse['data']; // Assign the whole map
        });
      } else {
        setState(() {
          _data = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data not found for the given email.')),
        );
      }
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${response.statusCode}')),
      );
    }
  }

  Future<void> _verifikasi(String status, String email) async {
    final String apiUrl =
        "https://ppdbspendap.agsa.site/api/formulir/status.php";

    final response = await http.put(
      Uri.parse(apiUrl),
      body: jsonEncode({
        "status": status,
        "email": email,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status diperbarui')),
      );
      Navigator.of(context).pushReplacementNamed('/admin_home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status')),
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
          "Detail Verifikasi",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: SingleChildScrollView(
          child: _data == null
              ? Center(child: CircularProgressIndicator())
              : Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Detail Data Peserta Didik Baru",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700]),
                          ),
                        ),
                        SizedBox(height: 10),
                        buildTextDisplay("Nama Lengkap", _data!['name']),
                        SizedBox(height: 10),
                        buildTextDisplay("NIK", _data!['nik']),
                        SizedBox(height: 10),
                        buildTextDisplay("Agama", _data!['religion']),
                        SizedBox(height: 10),
                        buildTextDisplay(
                            "Tempat Lahir", _data!['place_of_birth']),
                        SizedBox(height: 10),
                        buildTextDisplay(
                            "Tanggal Lahir", _data!['date_of_birth']),
                        SizedBox(height: 10),
                        buildTextDisplay("Jenis Kelamin", _data!['gender']),
                        SizedBox(height: 10),
                        buildTextDisplay("Asal Sekolah", _data!['school']),
                        SizedBox(height: 10),
                        buildTextDisplay("Alamat Lengkap", _data!['address']),
                        SizedBox(height: 10),
                        buildTextDisplay("Email", _data!['email']),
                        SizedBox(height: 10),
                        buildTextDisplay("No. HP", _data!['phone']),
                        SizedBox(height: 10),
                        buildFileDisplay("Ijazah", _data!['ijazah']),
                        SizedBox(height: 10),
                        buildFileDisplay("SKHU", _data!['skhu']),
                        SizedBox(height: 10),
                        buildFileDisplay("Pas Foto", _data!['pas_foto']),
                        SizedBox(height: 10),
                        buildFileDisplay("Kartu Keluarga", _data!['kk']),
                        SizedBox(height: 10),
                        buildTextDisplay("Status", _data!['status']),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await _verifikasi('Sudah', _data!['email']);
                              },
                              child: Text(
                                'Terima',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await _verifikasi('Ditolak', _data!['email']);
                              },
                              child: Text('Tolak',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget buildTextDisplay(String labelText, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFileDisplay(String labelText, String? fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: fileName == null || fileName.isEmpty
                ? Text(
                    "Data belum ada",
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  )
                : InkWell(
                    onTap: () async {
                      final url =
                          'https://ppdbspendap.agsa.site/assets/$fileName';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch $url')),
                        );
                      }
                    },
                    child: Text(
                      fileName,
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
