import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class Teeth2 extends StatefulWidget {
  @override
  _Teeth2State createState() => _Teeth2State();
}

class _Teeth2State extends State<Teeth2> {
  final String streamUrl = 'http://192.168.4.1:81/stream';
  final String captureUrl = 'http://192.168.4.1/capture';
  bool _isCapturing = false;
  File? _image;
  String? _analysisResult;
  bool _isAnalyzing = false;
  bool _isStreaming = false;
  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  static const platform = MethodChannel('com.example.capstone2/network');

  @override
  void initState() {
    super.initState();
  }

  Future<void> _captureImage() async {
    setState(() {
      _isCapturing = true;
    });
    try {
      final response = await http.get(Uri.parse(captureUrl));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final directory = await getTemporaryDirectory();
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final file = File('${directory.path}/captured_image_$timestamp.png');
        await file.writeAsBytes(bytes);
        setState(() {
          _image = file;
          _isCapturing = false;
        });
        _analyzeAndUploadImage(file);
      } else {
        throw Exception('Failed to capture image');
      }
    } catch (e) {
      setState(() {
        _isCapturing = false;
      });
      print("Failed to capture image: $e");
    }
  }

  Future<void> _analyzeAndUploadImage(File image) async {
    setState(() {
      _isAnalyzing = true;
    });
    String result;
    bool isCavityDetected = false;
    try {
      result = await platform.invokeMethod('analyzeImage', {'path': image.path});
      isCavityDetected = result.contains('Detected cavities');
      setState(() {
        _isAnalyzing = false;
        _analysisResult = isCavityDetected ? '양치가 제대로 되지 않은 부분이 있습니다.' : '치아 건강 위험이 발견되지 않았습니다.';
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = '분석 중 오류가 발생했습니다.';
      });
      print("Failed to analyze image: '${e.message}'.");
      return;
    }

    await _uploadImageToFirebase(image, isCavityDetected);
  }

  Future<void> _uploadImageToFirebase(File image, bool isCavityDetected) async {
    final user = auth.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }
    final userId = user.uid;

    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageRef = storage.ref().child('images/$userId/$fileName');
      UploadTask uploadTask = storageRef.putFile(image);

      await uploadTask.whenComplete(() async {
        String downloadURL = await storageRef.getDownloadURL();

        await firestore.collection('users').doc(userId).collection('images').add({
          'url': downloadURL,
          'timestamp': FieldValue.serverTimestamp(),
          'output': isCavityDetected,
        });
        print("Image uploaded and data saved to Firestore");
      }).catchError((error) {
        print("Failed to upload image: $error");
      });
    } catch (e) {
      print("Failed to upload image and save data: $e");
    }
  }

  void _startStream() {
    setState(() {
      _isStreaming = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width * 0.7;
    final buttonFontSize = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      backgroundColor: Color(0xffe0f7fa), // 배경색 변경
      appBar: AppBar(
        backgroundColor: Color(0xffe0f7fa), // 배경색 변경
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startStream,
              child: Text('영상 보기', style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold, color: Color(0xff6eb1d9))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                fixedSize: Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isStreaming
                ? Container(
              width: containerWidth,
              height: containerWidth,
              child: Mjpeg(
                stream: streamUrl,
                isLive: true,
              ),
            )
                : Container(),
            _image != null
                ? Column(
              children: [
                Container(
                  width: containerWidth,
                  child: Image.file(_image!),
                ),
                SizedBox(height: 20),
                _isAnalyzing
                    ? Text(
                  '잠시만 기다려주세요',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                )
                    : Text(
                  _analysisResult ?? '분석 중 오류가 발생했습니다.',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ],
            )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isCapturing ? null : _captureImage,
              child: _isCapturing ? CircularProgressIndicator() : Text('촬영', style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold,  color: Color(0xff6eb1d9))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                fixedSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
