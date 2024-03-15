import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class Info extends StatefulWidget {
  final String name;
  final String email;
  final String phonenumber;
  const Info({super.key,
  required this.name,
  required this.email,
  required this.phonenumber});
  @override
  _Info createState() => _Info();
}

class _Info extends State<Info> {
  List<String> placeDates = [];
  String selectedPlaceDate = '';
  String place = '';
  String name = ''; // 사용자 이름 변수 추가
  String email = ''; // 사용자 이메일 변수 추가
  String phonenumber = ''; // 사용자 전화번호 변수 추가

  

  @override
  void initState() {
    super.initState();
    name = widget.name; // 사용자 이름 설정
    email = widget.email; // 사용자 이메일 설정
    phonenumber = widget.phonenumber; // 사용자 전화번호 설정
    fetchData();
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

  String removeAfterSlash(String input) {
    List<String> parts = input.split(' / ');
    if (parts.isNotEmpty) {
      return parts.first; // 첫 번째 부분만 반환
    }
    return input; // ' / '를 찾지 못한 경우 입력 문자열 그대로 반환
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('${AppConfig.baseUrl}/past_place_name'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['results'] != null &&
          responseData['results'].length > 0) {
        final results = responseData['results'];
        List<String> tempPlaceDates = [];
        for (final result in results) {
          final place = result['Name'] ?? '';
          final date = result['Date'] ?? '';
          final placeDate = '$place / $date';
          tempPlaceDates.add(placeDate);
        }
        setState(() {
          placeDates = tempPlaceDates;
          selectedPlaceDate = placeDates[0];
        });
      } else {
        setState(() {
          placeDates = ['데이터 없음'];
        });
      }
    } else {
      setState(() {
        placeDates = ['데이터 없음'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          '신청내역 확인',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 102, 133, 159),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity, // 화면 너비에 맞게 조정
                child: DropdownButton(
                  isExpanded: true,
                  value: selectedPlaceDate,
                  items:
                      placeDates.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        // 텍스트 가운데 정렬
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold, // 텍스트 색상
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPlaceDate = newValue.toString();
                    });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // 드롭다운 버튼 텍스트 색상
                  ),
                  dropdownColor: Colors.white, // 드롭다운 목록 배경색
                  icon: const Icon(
                    Icons.arrow_drop_down, // 드롭다운 아이콘
                    color: Colors.black, // 아이콘 색상
                  ),
                  underline: Container(
                    height: 0, // 드롭다운 버튼 아래 테두리 높이
                    color: const Color.fromARGB(255, 102, 157, 159), // 테두리 색상 (흰색)
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity, // 화면 너비에 맞게 조정
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2),
                  ),
                  onPressed: () async {
                    
                    final placeDate = selectedPlaceDate;
                    final place = removeAfterSlash(placeDate);
                    final response = await http.post(
                      Uri.parse('${AppConfig.baseUrl}/check'),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        'email': email,
                        'name': name,
                        'place': place,
                      }),
                    );

                    if (response.statusCode == 200) {
                        customShowDialog(context, '이미 신청하셨습니다.\n자세한 내용은 이메일을 확인해주세요.');
                    } else if (response.statusCode == 500) {
                      customShowDialog(context, '신청 내역이 없습니다.');
                    } else {
                      customShowDialog(context, '서버 오류로 인해 신청에 실패했습니다.');
                    }
                  },
                  child: const Text(
                    '조회하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
