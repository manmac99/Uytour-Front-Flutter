import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secondmain.dart';
import 'config.dart';
import 'Register.dart';
import 'Fpass.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '우연 투어',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromARGB(255, 128, 153, 173),
      ),
      home: MyHomePage(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = FlutterSecureStorage();
  final TextEditingController ID = TextEditingController();
  final TextEditingController Password = TextEditingController();




  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  Future<void> _autoLogin() async {
      String? token = await storage.read(key: 'login');
      if (token != null) {
          final Map<String, dynamic> loginInfo = jsonDecode(token);
          final String email = loginInfo['email'];
          final String pass = loginInfo['pass'];
         

      // 토큰이 있을 경우 자동 로그인 시도
      // 서버에 토큰을 이용한 로그인 요청을 보내고, 성공 시 다음 화면으로 이동
      // 이 과정은 로그인 페이지의 onPressed 함수와 유사하게 구현
      // 필요에 따라 서버와의 통신 로직을 분리하여 별도의 함수로 구현하는 것이 좋습니다.
      // 예시 코드에서는 간단한 형태로 표현하였습니다.
      
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/login2'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email' : email, 'pass':pass}),
      );
        
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final email = responseData['email'];
        final name = responseData['name'];
        final phonenumber = responseData['phonenumber'];

        
        // 로그인 성공
        Navigator.pushAndRemoveUntil(
        context,
          MaterialPageRoute(builder: (context) => Second(name: name, email: email, phonenumber: phonenumber)),
        (route) => false,
        );
      } else{
        // 로그인 실패 또는 토큰이 만료됨
        // 토큰 삭제 또는 로그아웃 처리를 해야 할 수도 있음
        await storage.delete(key: 'login', );
      }
    } 
  }

    void customShowDialog(BuildContext context, String content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.black, width: 3.0),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Text(
            content,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
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
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/Main.jpg',
                  width: 400,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      '우연 투어',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 60,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(150, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'UY tour',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(150, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: ID,
                decoration: InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: Password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2), // 검은색 테두리 추가
              ),
              
              onPressed: () async {
  final email2 = ID.text;
  final pass = Password.text;
  
    // 위의 조건을 만족하지 않을 때 처리
    // 서버로부터 받은 응답에 따라 다른 다이얼로그를 표시
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/Assigned'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email2}),
    );

    if (response.statusCode == 200) {
      final response2 = await http.post(
        Uri.parse('${AppConfig.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email2, 'pass': pass}),
      );

      if (response2.statusCode == 200) {
        // 성공적으로 로그인한 경우
        // '로그인 성공!' 다이얼로그를 표시하고 다음 화면으로 이동
        String token = json.decode(response2.body)['token'];
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        final email = payload['email'];
        final name = payload['name'];
        final password = payload['password'];
        final phonenumber = payload['phonenumber'];
        var val = jsonEncode(Login(email, password, name, phonenumber));
        await storage.write(key: 'login', value: val);
        customShowDialog(context, "로그인 성공!");

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => Second(name: name, email: email, phonenumber: phonenumber)),
  (route) => false,
);
        });
      } else if (response2.statusCode == 300) {
        customShowDialog(context, "비밀번호가 틀렸습니다.");
      } else {
        customShowDialog(context, "서버 오류로 로그인에 실패했습니다.");
      }
    } else if (response.statusCode == 300) {
      customShowDialog(context, "가입된 이메일이 아닙니다.");
    } else {
      customShowDialog(context, "서버 오류로 로그인에 실패했습니다.");
    }
  
},
              child: Text(
                '로그인',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              child: Text(
                '회원가입',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Fpass1()),
                );
              },
              child: Text(
                '비밀번호 찾기',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}