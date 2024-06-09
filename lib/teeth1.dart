import 'package:flutter/material.dart';
import 'teeth2.dart';
import 'package:flutter/services.dart';

class Teeth1 extends StatelessWidget {
  static const platform = MethodChannel('com.example.capstone2/network');

  Future<void> _openWifiSettings() async {
    try {
      await platform.invokeMethod('openWifiSettings');
    } on PlatformException catch (e) {
      print("Failed to open WiFi settings: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fontSize = screenSize.width * 0.04; // 반응형 폰트 크기
    final buttonFontSize = screenSize.width * 0.05;
    final textColor = Color(0xff6eb1d9); // 텍스트 색상 변경

    return Scaffold(
      backgroundColor: Color(0xffe0f7fa), // 배경색 변경
      appBar: AppBar(
        backgroundColor: Color(0xffe0f7fa), // 배경색 변경
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '1. 디바이스 하단부의\n    전원 스위치를 누르세요.',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: screenSize.height * 0.01), // 여백 줄임
                    Text(
                      '2. 카메라 와이파이에 연결해주세요.',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: screenSize.height * 0.01), // 여백 줄임
                    Text(
                      '3. GO 버튼을 눌러 영상을 확인하세요.',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: screenSize.height * 0.01), // 여백 줄임
                    Text(
                      '4. 디바이스 상단부를 입에 넣으세요.',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: screenSize.height * 0.01), // 여백 줄임
                    Text(
                      '5. 치아가 잘 촬영되도록\n    각도를 조절한 뒤\n    촬영 버튼을 누르세요.',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: screenSize.height * 0.01), // 여백 줄임
                    Text(
                      '6. 인터넷 와이파이에 연결해주세요.',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Center(
                child: Image.asset('assets/images/refer.png', width: screenSize.width * 0.8), // 이미지 추가, 경로를 실제 이미지 경로로 변경
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _openWifiSettings,
                    child: Text('와이파이 설정', style: TextStyle(fontSize: buttonFontSize * 0.8, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: textColor,
                      minimumSize: Size(screenSize.width * 0.35, screenSize.height * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Teeth2()),
                      );
                    },
                    child: Text('GO', style: TextStyle(fontSize: buttonFontSize, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: textColor,
                      minimumSize: Size(screenSize.width * 0.35, screenSize.height * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
