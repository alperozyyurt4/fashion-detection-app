import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImagePredictionPage extends StatefulWidget {
  const ImagePredictionPage({super.key});

  @override
  _ImagePredictionPageState createState() => _ImagePredictionPageState();
}

class _ImagePredictionPageState extends State<ImagePredictionPage> {
  File? _image;
  String _prediction = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resim Seçin'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'gallery');
              },
              child: Text('Galeri'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'camera');
              },
              child: Text('Kamera'),
            ),
          ],
        );
      },
    );

    if (pickedOption != null) {
      XFile? pickedFile;
      if (pickedOption == 'gallery') {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      } else if (pickedOption == 'camera') {
        pickedFile = await picker.pickImage(source: ImageSource.camera);
      }

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile!.path);
          _prediction = ''; // Reset prediction when new image is selected
        });
        _predictImage(_image!);
      }
    }
  }

  Future<void> _predictImage(File imageFile) async {
    final uri = Uri.parse('http://192.168.1.39:5002/predict');
    final request = http.MultipartRequest('POST', uri);

    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseJson = json.decode(responseBody);

        setState(() {
          _prediction = '${responseJson['class']}';
        });

        Fluttertoast.showToast(msg: "Tahmin: ${responseJson['class']}");
      } else {
        setState(() {
          _prediction = 'Tahmin yapılamadı, lütfen tekrar deneyin.';
        });
        Fluttertoast.showToast(msg: 'Tahmin yapılamadı.');
      }
    } catch (e) {
      setState(() {
        _prediction = 'Bir hata oluştu: $e';
      });
      Fluttertoast.showToast(msg: 'Bir hata oluştu: $e');
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
      _prediction = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient arka plan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Başlık
                    Text(
                      "Resimle Sınıf Tahmini",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    if (_image != null)
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _image!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _prediction.isNotEmpty ? _prediction : 'Tahmin bekleniyor...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _clearImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                            ),
                            child: Text(
                              'Resmi Temizle',
                              style: TextStyle(
                                color: Color(0xFF0072FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Bir resim seçin veya çekin',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                            ),
                            child: Text(
                              'Resim Seç veya Çek',
                              style: TextStyle(
                                color: Color(0xFF0072FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
