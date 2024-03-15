import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class WriteReview extends StatefulWidget {
  final String placeName;
  final String name;
  final String email;
  final String phonenumber;
  const WriteReview({super.key, required this.placeName,
  required this.name,
  required this.email,
  required this.phonenumber});
  @override
  _WriteReview createState() => _WriteReview();
}

class _WriteReview extends State<WriteReview> {
 
  String selectedEmailDomain = '@gmail.com';
  
  TextEditingController reviewController = TextEditingController();
  
  String name = ''; // 사용자 이름 변수 추가
  String email = ''; // 사용자 이메일 변수 추가
  String phonenumber = ''; // 사용자 전화번호 변수 추가

   @override
  void initState() {
    super.initState();
    name = widget.name; // 사용자 이름 설정
    email = widget.email; // 사용자 이메일 설정
    phonenumber = widget.phonenumber; // 사용자 전화번호 설정
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
      appBar: AppBar(
        title: const Text(
          '투어 후기 작성하기',
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
            Text(
              '투어 장소: ${widget.placeName}\n',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            
            
            
            const SizedBox(height: 20),
            TextField(
              controller: reviewController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: '투어 후기',
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
                
                final review = reviewController.text;
                final placeName = widget.placeName;

                final response = await http.post(
                  Uri.parse('${AppConfig.baseUrl}/check'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'email': email,
                    'name': name,
                    'place': placeName,
                  }),
                );

                if (response.statusCode == 200) {
                  final response2 = await http.post(
                    Uri.parse('${AppConfig.baseUrl}/Add_review'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({
                      'email': email,
                      'name': name,
                      'review': review,
                      'place': placeName,
                    }),
                  );
                  if (response2.statusCode == 200) {
                    customShowDialog(context, '후기 작성이 완료되었습니다.\n 작성해주셔서 감사합니다.');
                  } else {
                    customShowDialog(context, '서버 오류로 인해 작성에 실패했습니다.');
                  }
                } else if (response.statusCode == 500) {
                  customShowDialog(context, '$placeName 투어를 참가하지 않았습니다.');
                } else {
                    customShowDialog(context, '서버 오류로 인해 작성에 실패했습니다.');
                }
              },
              child: const Text(
                '작성하기',
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
