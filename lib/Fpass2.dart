import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uyproj1/main.dart';
import 'dart:convert';
import 'config.dart';

class Fpass2 extends StatefulWidget {
  final String email;
  const Fpass2({super.key, required this.email});
  @override
  _Fpass2 createState() => _Fpass2();
}

class _Fpass2 extends State<Fpass2> {

  TextEditingController pass1Controller = TextEditingController();
  TextEditingController pass2Controller = TextEditingController();

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
      appBar: AppBar(
        title: const Text(
          '비밀번호 재설정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 102, 133, 159),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: pass1Controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pass2Controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비빌번호 확인',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              onPressed: () async {
                final email = widget.email;
                final pass1 = pass1Controller.text;
                final pass2 = pass2Controller.text;
                if (pass1 != pass2) {
                  customShowDialog(context, '비밀번호가 일치하지 않습니다.');
                } else if (pass1.length < 8 || pass2.length < 8) {
                  customShowDialog(context, '비밀번호는 최소 8글자 이상이어야 합니다!');
                } else if (!RegExp(
                            r'^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9!@#$%^&*]*$')
                        .hasMatch(pass1) ||
                    !RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9!@#$%^&*]*$')
                        .hasMatch(pass2)) {
                    customShowDialog(context, '비밀번호는 영어와 숫자는 필수입니다.');
                }
                // else if (phone.length <= 11 || phone.length >= 20) {
                //   setState(() {
                //     responseMessage = '전화번호는 11자 이상 20자 이하여야 합니다.';
                //   });
                //}
                else {
                  final response = await http.post(
                    Uri.parse('${AppConfig.baseUrl}/reset_password'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'email': email,
                      'pass': pass1,
                    }),
                  );
                  if (response.statusCode == 200) {
                    customShowDialog(context, '비밀번호 재설정 성공!');
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );
                      });
                  } else if (response.statusCode == 500) {
                    customShowDialog(context, '서버 오류로 인해 작성에 실패했습니다.');
                  } else {
                    customShowDialog(context, '서버 오류로 인해 작성에 실패했습니다.');
                  }
                }
              },
              child: const Text(
                '재설정하기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
