import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class FormulirPendaftaranPage extends StatefulWidget {
  const FormulirPendaftaranPage({super.key});

  @override
  State<FormulirPendaftaranPage> createState() =>
      _FormulirPendaftaranPageState();
}

class _FormulirPendaftaranPageState extends State<FormulirPendaftaranPage> {
  File? _ijazahSdFile;
  File? _skhuFile;
  File? _pasFotoFile;
  File? _kkFile;

  final ImagePicker _picker = ImagePicker();
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

  Future<void> _pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case 'Ijazah SD':
            _ijazahSdFile = File(pickedFile.path);
            break;
          case 'SKHU':
            _skhuFile = File(pickedFile.path);
            break;
          case 'Pas Foto':
            _pasFotoFile = File(pickedFile.path);
            break;
          case 'KK':
            _kkFile = File(pickedFile.path);
            break;
        }
      });
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
        "https://ppdbspendap.agsa.site/api/formulir/create.php";

    final response = await http.post(
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
        SnackBar(content: Text('Formulir berhasil disimpan')),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan formulir')),
      );
    }
  }

  void _saveForm() {
    _submitForm();
  }

  void _cancelForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Formulir dibatalkan')),
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
          "Formulir Pendaftaran",
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
                  buildTextField("Email", "Masukkan Email", _emailController),
                  SizedBox(height: 10),
                  buildNumericField(
                      "No. HP", "Masukkan No.HP", _phoneController),
                  SizedBox(height: 20),
                  Text(
                    "Upload Dokumen :",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  buildUploadField("Ijazah SD", _ijazahSdFile),
                  SizedBox(height: 10),
                  buildUploadField("SKHU", _skhuFile),
                  SizedBox(height: 10),
                  buildUploadField("Pas Foto", _pasFotoFile),
                  SizedBox(height: 10),
                  buildUploadField("KK", _kkFile),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(
                          'Simpan',
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
      String labelText, String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                hintText: hintText,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumericField(
      String labelText, String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                hintText: hintText,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _agama,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                hintText: hintText,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (newValue) {
                setState(() {
                  _agama = newValue;
                });
              },
              items: <String>['Islam', 'Kristen', 'Hindu', 'Buddha', 'Konghucu']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _tglLahirController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    hintText: hintText,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: 'Laki-laki',
                      groupValue: _jenisKelamin,
                      onChanged: (value) {
                        setState(() {
                          _jenisKelamin = value;
                        });
                      },
                    ),
                    Text('Laki-laki'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Perempuan',
                      groupValue: _jenisKelamin,
                      onChanged: (value) {
                        setState(() {
                          _jenisKelamin = value;
                        });
                      },
                    ),
                    Text('Perempuan'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUploadField(String labelText, File? file) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            child: Text(
              labelText,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(labelText),
                  child: Text(
                    file == null ? 'Upload' : 'File Selected',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                if (file != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Selected: ${file.path.split('/').last}',
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.black54),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
