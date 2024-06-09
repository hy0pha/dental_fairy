import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart'; // 홈 화면으로 이동하기 위해 import

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fontSize = screenSize.width * 0.045; // 반응형 폰트 크기
    final buttonFontSize = screenSize.width * 0.05;
    final textColor = Color(0xff6eb1d9); // 텍스트 색상 변경

    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA), // 배경색 설정
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/dental_fairy_logo.png',
                  width: screenSize.width * 0.68,
                  height: screenSize.width * 0.73,
                ), // 중앙 이미지
                Image.asset(
                  'assets/images/dental_fairy_text.png',
                  width: screenSize.width * 0.65,
                  height: screenSize.width * 0.23,
                ), // Dental Fairy 텍스트 이미지
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  '당신을 위한 구강 건강 홈케어 서비스',
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(screenSize.width * 0.05),
            child: ElevatedButton(
              onPressed: () async {
                await signInWithGoogle(context);
              },
              child: Text('시작하기', style: TextStyle(fontSize: buttonFontSize)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: textColor,
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.08,
                  vertical: screenSize.height * 0.02,
                ),
                textStyle: TextStyle(fontSize: buttonFontSize),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(double.infinity, screenSize.height * 0.07), // 버튼을 화면 너비에 맞게 설정
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _account = await _googleSignIn.signIn();

  if (_account != null) {
    GoogleSignInAuthentication _authentication = await _account.authentication;
    OAuthCredential _googleCredential = GoogleAuthProvider.credential(
      idToken: _authentication.idToken,
      accessToken: _authentication.accessToken,
    );

    UserCredential _credential = await _firebaseAuth.signInWithCredential(_googleCredential);

    if (_credential.user != null) {
      User? user = _credential.user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('성공적으로 로그인되었습니다: ${user?.displayName}'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)), // 로그인 후 홈 페이지로 이동
      );
    }
  }
}
