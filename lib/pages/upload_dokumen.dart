import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UploadDokumen extends StatefulWidget {
  @override
  _UploadDokumenState createState() => _UploadDokumenState();
}

class _UploadDokumenState extends State<UploadDokumen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late String email;

  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    String? thisEmail = await _secureStorage.read(key: 'email');
    setState(() {
      email = thisEmail ?? '';
    });
  }

  File? ijazahFile;
  File? skhuFile;
  File? pasFotoFile;
  File? kkFile;

  String getFileName(File? file) {
    return file != null ? file.path.split('/').last : 'Belum Dipilih';
  }

  Future<void> _pickImage(
      ImageSource source, Function(File pickedFile) setImage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setImage(File(pickedFile.path));
    }
  }

  Future<void> _uploadFile(String url, String fieldName, File? file) async {
    if (file == null) {
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload $fieldName berhasil')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload $fieldName gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Dokumen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            _buildFilePickerButton('Ijazah', ijazahFile, (File pickedFile) {
              setState(() {
                ijazahFile = pickedFile;
              });
            }),
            SizedBox(height: 20.0),
            _buildFilePickerButton('SKHU', skhuFile, (File pickedFile) {
              setState(() {
                skhuFile = pickedFile;
              });
            }),
            SizedBox(height: 20.0),
            _buildFilePickerButton('Pas Foto', pasFotoFile, (File pickedFile) {
              setState(() {
                pasFotoFile = pickedFile;
              });
            }),
            SizedBox(height: 20.0),
            _buildFilePickerButton('KK', kkFile, (File pickedFile) {
              setState(() {
                kkFile = pickedFile;
              });
            }),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _uploadFile(
                  'https://ppdbspendap.agsa.site/api/dokumen/ijazah.php?email=$email',
                  'ijazah',
                  ijazahFile,
                );
                _uploadFile(
                  'https://ppdbspendap.agsa.site/api/dokumen/skhu.php?email=$email',
                  'skhu',
                  skhuFile,
                );
                _uploadFile(
                  'https://ppdbspendap.agsa.site/api/dokumen/foto.php?email=$email',
                  'pas_foto',
                  pasFotoFile,
                );
                _uploadFile(
                  'https://ppdbspendap.agsa.site/api/dokumen/kk.php?email=$email',
                  'kk',
                  kkFile,
                );
              },
              child: Text('Upload File'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text('Kembali'),
            ),
            Text('Kembali setelah 4 dokumen berhasil diupload.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePickerButton(
      String label, File? file, Function(File pickedFile) setImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$label: ${getFileName(file)}'),
        ElevatedButton(
          onPressed: () {
            _pickImage(ImageSource.gallery, setImage);
          },
          child: Text('Pilih $label'),
        ),
      ],
    );
  }
}
