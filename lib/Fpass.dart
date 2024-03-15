import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uyproj1/Fpass2.dart';
import 'dart:convert';
import 'config.dart';

class Fpass1 extends StatefulWidget {
  const Fpass1({super.key});
  @override
  _Fpass1 createState() => _Fpass1();
}

class _Fpass1 extends State<Fpass1> {
  TextEditingController emailController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  bool isvalid = false;

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
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: '이메일',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side:
                        const BorderSide(color: Colors.black, width: 2), // 검은색 테두리 추가
                  ),
                  onPressed: () async {
                    final email = emailController.text;
                    final response = await http.post(
                      Uri.parse('${AppConfig.baseUrl}/Assigned'),
                      body: json.encode({'email': email}),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 200) {
                      final response2 = await http.post(
                        Uri.parse('${AppConfig.baseUrl}/vericode2'),
                        body: json.encode({'email': email}),
                        headers: {'Content-Type': 'application/json'},
                      );
                      if (response2.statusCode == 200) {
                        setState(() {
                          isvalid = true;
                        });
                        customShowDialog(context, '인증번호 발송이 완료되었습니다.');
                      } else {
                        customShowDialog(context, '이메일 주소가 틀렸습니다.\n다시 입력해주세요.');
                      }
                      
                    } else if (response.statusCode == 400) {
                      customShowDialog(context, '서버 오류에 인해 인증번호 전송에 실패했습니다.');
                    } else {
                      customShowDialog(context, '가입 내역이 없습니다.');
                    }
                  },
                  child: const Text(
                    '인증번호 발송',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: verificationCodeController,
              decoration: const InputDecoration(
                labelText: '인증번호',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              enabled: isvalid, // isvalid 상태에 따라 활성/비활성 설정
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2),
              ),
              onPressed: isvalid
                  ? () async {
                      final email = emailController.text;
                      final vericode = verificationCodeController.text;

                      final response = await http.post(
                        Uri.parse('${AppConfig.baseUrl}/check_veri'),
                        body:
                            json.encode({'email': email, 'vericode': vericode}),
                        headers: {'Content-Type': 'application/json'},
                      );

                      if (response.statusCode == 200) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Fpass2(email: email),
                          ),
                        );
                      } else if (response.statusCode == 400) {
                        customShowDialog(context, '인증번호가 틀렸습니다.');
                      } else {
                          customShowDialog(context, '서버 오류');
                      }
                    }
                  : null,
              child: const Text(
                '인증하기',
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
