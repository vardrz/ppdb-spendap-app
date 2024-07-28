import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditFormulirPendaftaranPage extends StatefulWidget {
  const EditFormulirPendaftaranPage({super.key});

  @override
  State<EditFormulirPendaftaranPage> createState() =>
      _EditFormulirPendaftaranPageState();
}

class _EditFormulirPendaftaranPageState
    extends State<EditFormulirPendaftaranPage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _agama;
  String? _jenisKelamin;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String? email = await _secureStorage.read(key: 'email');
    if (email != null) {
      _emailController.text = email;
      await _fetchFormData(email);
    }
  }

  Future<void> _fetchFormData(String email) async {
    final String apiUrl =
        "https://ppdbspendap.agsa.site/api/formulir/get.php?email=$email";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final formData = data['data'];

        setState(() {
          _nameController.text = formData['name'];
          _nikController.text =
              formData['nik'].toString(); // Convert to string if needed
          _agama = formData['religion'];
          _tempatLahirController.text = formData['place_of_birth'];
          _tglLahirController.text = formData['date_of_birth'];
          _jenisKelamin = formData['gender'];
          _schoolController.text = formData['school'];
          _addressController.text = formData['address'];
          _phoneController.text = formData['phone'];
          _emailController.text = formData['email'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data formulir')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data formulir')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tglLahirController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _submitForm() async {
    final String apiUrl =
        "https://ppdbspendap.agsa.site/api/formulir/update.php";

    final response = await http.put(
      Uri.parse(apiUrl),
      body: jsonEncode({
        "name": _nameController.text,
        "nik": _nikController.text,
        "religion": _agama,
        "place_of_birth": _tempatLahirController.text,
        "date_of_birth": _tglLahirController.text,
        "gender": _jenisKelamin,
        "school": _schoolController.text,
        "address": _addressController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Formulir berhasil diedit')),
      );
      Navigator.of(context).pushReplacementNamed('/uploaddokumen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengubah formulir')),
      );
    }
  }

  void _saveForm() {
    _submitForm();
  }

  void _cancelForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Perubahan Formulir dibatalkan')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        centerTitle: true,
        title: Text(
          "Edit Formulir Pendaftaran",
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
          child: Card(
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
                      "Formulir Pendaftaran Peserta Didik Baru Tahun 2024/2025",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700]),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Isi formulir dibawah ini dengan baik dan benar",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                      "Nama Lengkap", "Masukkan nama lengkap", _nameController),
                  SizedBox(height: 10),
                  buildNumericField("NIK", "Masukkan NIK", _nikController),
                  SizedBox(height: 10),
                  buildDropdownField("Agama", "Pilih agama"),
                  SizedBox(height: 10),
                  buildTextField("Tempat Lahir", "Masukkan tempat lahir",
                      _tempatLahirController),
                  SizedBox(height: 10),
                  buildDateField("Tanggal Lahir", "Pilih tanggal lahir"),
                  SizedBox(height: 10),
                  buildRadioField("Jenis Kelamin"),
                  SizedBox(height: 10),
                  buildTextField("Asal Sekolah", "Masukkan asal sekolah",
                      _schoolController),
                  SizedBox(height: 10),
                  buildTextField("Alamat Lengkap", "Masukkan alamat lengkap",
                      _addressController),
                  SizedBox(height: 10),
                  buildTextField("Email", "Masukkan Email", _emailController,
                      enabled: false), // Disable email TextField
                  SizedBox(height: 10),
                  buildNumericField(
                      "No. HP", "Masukkan No.HP", _phoneController),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Update',
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
                        onPressed: _cancelForm,
                        child: Text('Batal',
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

  Widget buildTextField(
      String labelText, String hintText, TextEditingController controller,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: TextFormField(
              enabled: enabled,
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: hintText,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumericField(
      String labelText, String hintText, TextEditingController controller) {
    return buildTextField(labelText, hintText, controller);
  }

  Widget buildDropdownField(String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _agama,
              hint: Text(hintText),
              items: <String>['Islam', 'Kristen', 'Katholik', 'Hindu', 'Budha']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _agama = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateField(String labelText, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _tglLahirController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: hintText,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioField(String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio<String>(
                  value: 'L',
                  groupValue: _jenisKelamin,
                  onChanged: (String? value) {
                    setState(() {
                      _jenisKelamin = value;
                    });
                  },
                ),
                Text('Laki-laki'),
                Radio<String>(
                  value: 'P',
                  groupValue: _jenisKelamin,
                  onChanged: (String? value) {
                    setState(() {
                      _jenisKelamin = value;
                    });
                  },
                ),
                Text('Perempuan'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
