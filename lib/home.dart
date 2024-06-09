import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signin.dart'; // SignInPage를 import
import 'teeth1.dart'; // Import the new TeethCheckPage
import 'place.dart'; // Import the PlacePage
import 'record.dart'; // Import the RecordPage

class HomePage extends StatelessWidget {
  final User? user;

  HomePage({this.user});

  Future<String> _getLastCheckDate() async {
    final userId = user?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('images')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final timestamp = snapshot.docs.first.get('timestamp') as Timestamp;
      final date = timestamp.toDate();
      return '최종 검사일: ${date.year}. ${date.month.toString().padLeft(2, '0')}. ${date.day.toString().padLeft(2, '0')}';
    } else {
      return '검사 기록이 없습니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 사용자 이메일에서 "@" 앞 부분 추출
    String userId = user?.email?.split('@')[0] ?? 'ID';
    final screenSize = MediaQuery.of(context).size;
    final buttonHeight = screenSize.height * 0.15 * 1.3; // 화면 높이에 비례한 버튼 높이를 1.5배로 조정
    final fontSize = screenSize.width * 0.06; // 화면 너비에 비례한 폰트 크기
    final textColor = Color(0xff3d5768); // 텍스트 색상

    return Scaffold(
      backgroundColor: Color(0xffe0f7fa), // 배경색 변경
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: screenSize.height * 0.06),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // 박스 색상
                borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
              ),
              child: Column(
                children: [
                  Text(
                    '반갑습니다, $userId 님!', // 이메일에서 추출한 ID 사용
                    style: TextStyle(fontSize: fontSize*0.9, fontWeight: FontWeight.bold, color: textColor), // 글자 색 변경
                  ),
                  FutureBuilder<String>(
                    future: _getLastCheckDate(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('오류가 발생했습니다.', style: TextStyle(fontSize: fontSize*0.9, fontWeight: FontWeight.bold, color: textColor));
                      } else {
                        return Text(
                          snapshot.data ?? '검사 기록이 없습니다.',
                          style: TextStyle(fontSize: fontSize*0.9, fontWeight: FontWeight.bold, color: textColor), // 글자 색 변경
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenSize.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width * 0.1), // 왼쪽 여백 추가
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Teeth1()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/detect_button.png', // 치아 건강 확인 버튼 이미지
                      height: buttonHeight,
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.07),
                Expanded(
                  child: Text(
                    '치아 확인',
                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor), // 글자 색 변경
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '치과 찾기',
                    style: TextStyle(fontSize: fontSize*1.1, fontWeight: FontWeight.bold, color: textColor), // 글자 색 변경
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: screenSize.width * 0.07), // 오른쪽 여백 추가
                Padding(
                  padding: EdgeInsets.only(right: screenSize.width * 0.05), // 오른쪽 여백 추가
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlacePage()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/place_button.png', // 근처 치과 찾기 버튼 이미지
                      height: buttonHeight,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: screenSize.width * 0.1), // 왼쪽 여백 추가
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecordPage()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/record_button.png', // 지난 기록 확인 버튼 이미지
                      height: buttonHeight,
                    ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.07),
                Expanded(
                  child: Text(
                    '지난 기록',
                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor), // 글자 색 변경
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.03),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: Text(
                '로그아웃',
                style: TextStyle(fontSize: fontSize*0.8, fontWeight: FontWeight.bold, color: textColor), // 글자 색 변경
              ),
            ),
          ],
        ),
      ),
    );
  }
}
