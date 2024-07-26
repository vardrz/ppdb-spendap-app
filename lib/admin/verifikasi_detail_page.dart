import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final response = await http.get(Uri.parse(
        'https://ppdbspendap.agsa.site/api/formulir/get.php?email=${widget.email}'));

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
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _data == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nama: ${_data!['name']}"),
                  Text("NIK: ${_data!['nik']}"),
                  Text("Agama: ${_data!['religion']}"),
                  Text("Tempat Lahir: ${_data!['place_of_birth']}"),
                  Text("Tanggal Lahir: ${_data!['date_of_birth']}"),
                  Text("Jenis Kelamin: ${_data!['gender']}"),
                  Text("Sekolah: ${_data!['school']}"),
                  Text("Alamat: ${_data!['address']}"),
                  Text("Telepon: ${_data!['phone']}"),
                  Text("Email: ${_data!['email']}"),
                  Text("Status: ${_data!['status']}"),
                  ElevatedButton(
                    onPressed: () async {
                      await _verifikasi('Sudah', _data!['email']);
                    },
                    child: Text(
                      'Terima',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _verifikasi('Ditolak', _data!['email']);
                    },
                    child: Text(
                      'Tolak',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
