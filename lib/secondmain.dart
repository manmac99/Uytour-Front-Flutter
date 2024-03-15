import 'package:flutter/material.dart';
import 'PastTourScreen.dart';
import 'NewTourScreen.dart';
import 'Info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';

class Second extends StatelessWidget {
  final String name;
  final String email;
  final String phonenumber; 

  const Second({super.key,
  required this.name,
  required this.email,
  required this.phonenumber});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '우연 투어',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 128, 153, 173),
      ),
      home: SecondPage(name: name, email: email, phonenumber: phonenumber),
    );
  }
}
 
class SecondPage extends StatelessWidget {
  final String name;
  final String email;
  final String phonenumber;

  const SecondPage({super.key,
  required this.name,
  required this.email,
  required this.phonenumber});

    Future<void> _logout(BuildContext context) async {
    // FlutterSecureStorage에서 사용자 정보 삭제
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'login');

    // 로그인 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Stack을 사용하여 이미지 위에 텍스트 배치
            Stack(
              alignment: Alignment.center, // 이미지 중앙에 텍스트를 위치시킵니다.
              children: <Widget>[
                Image.asset(
                  'assets/Main.jpg',
                  width: 400,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const Column(
                  children: <Widget>[
                    Text(
                      '우연 투어',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 60,
                        color: Colors.white, // 글씨 색상을 흰색으로 변경
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(150, 0, 0, 0), // 텍스트에 그림자 추가
                          ),
                        ],
                      ),
                    ),
                    Text(
                      //'우연히 만난 우리 인연 ', //feat 동동',
                      //'동동이와 진우',
                      'UY tour',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white, // 글씨 색상을 흰색으로 변경
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(150, 0, 0, 0), // 텍스트에 그림자 추가
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 이미지와 버튼 사이의 여백
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2), // 검은색 테두리 추가
              ),
              onPressed: () {
                Navigator.push( 
                  context,
                  MaterialPageRoute(builder: (context) =>  NewToursScreen(name: name, email: email, phonenumber: phonenumber)),
                );
              },
              child: const Text(
                '새로운 투어',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ), // 볼드체로 변경
              ),
            ),
            const SizedBox(height: 10), // 첫 번째 버튼과 두 번째 버튼 사이의 여백
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2), // 검은색 테두리 추가
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  PastToursScreen(name: name, email: email, phonenumber: phonenumber)),
                );
              },
              child: const Text(
                '지난 투어',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ), // 볼드체로 변경
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Info(name: name, email: email, phonenumber: phonenumber)),
                );
              },
              child: const Text(
                '신청내역 확인',
                style: TextStyle(
                  //decoration: TextDecoration.underline, // 밑줄 추가
                  color: Colors.black, // 텍스트 색상을 파란색으로 변경
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _logout(context),
              child: const Text(
                'Log out',
                style: TextStyle(
                  //decoration: TextDecoration.underline, // 밑줄 추가
                  color: Colors.black, // 텍스트 색상을 파란색으로 변경
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
