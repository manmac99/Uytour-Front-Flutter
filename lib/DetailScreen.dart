import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'Tour.dart';
//import 'ApplyTourScreen.dart';
import 'config.dart';


class DetailScreen extends StatelessWidget {
  final String tourName;
  final List<String> reviews;
  final String date;
  final int peopleWant;
  final int peopleReal;
  final Widget imageWidget;
  final String name;
  final String email;
  final String phonenumber;
  

  DetailScreen({super.key, 
    required this.tourName,
    required this.reviews,
    required this.date,
    required this.peopleWant,
    required this.peopleReal,
    required this.imageWidget,
  required this.name,
  required this.email,
  required this.phonenumber
  });

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
        title: Text(
          '상세 정보 - $tourName',
          style:  TextStyle(
            fontWeight: FontWeight.w800, // 두꺼운 글씨체
            fontSize: 20, // 원하는 폰트 크기
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 102, 133, 159), // AppBar 배경색 변경
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 모서리가 둥근 흰색 박스
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10), // 모서리를 둥글게
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            margin: const EdgeInsets.all(12), // 박스 주변 여백
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
// 이미지 위젯
                SizedBox(
                  height: 110,
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageWidget,
                  ),
                ),
                const SizedBox(width: 10), // 이미지와 텍스트 사이 간격
// 텍스트 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('날짜: $date',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('모집 인원: $peopleWant',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      Text('신청 인원: $peopleReal',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
// 후기 리스트를 Card로 감싸서 표시
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length + 1, // Add 1 for the '신청하기' button
              itemBuilder: (context, index) {
                if (index < reviews.length) {
                  // Review cards
                  return Card(
                    elevation: 4.0, // 그림자 효과
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게
                    ),
                    child: ListTile(
                      title: Text(
                        reviews[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600, // 폰트 두께를 semi-bold로 설정
                          fontSize: 16.0, // 폰트 크기 설정, 필요에 따라 조정 가능
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      // 내부 여백 설정
                    ),
                  );
                } else {
                  // Updated '신청하기' Button at the end of the list
                  return Padding(
                    padding: const EdgeInsets.all(10.0), // 원하는 여백 설정
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: const BorderSide(
                            color: Colors.black, width: 2), // 검은색 테두리 추가
                      ),
                      onPressed: () async {
                
                

                final response = await http.post(
                  Uri.parse('${AppConfig.baseUrl}/submit1'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'email': email,
                    'name': name,
                    'phoneNumber': phonenumber,
                    'placeName': tourName,
                    'date': date,
                  }),
                );

                if (response.statusCode == 200) {
                  final response2 =
                      await http.post(Uri.parse('${AppConfig.baseUrl}/submit2'),
                          headers: {'Content-Type': 'application/json'},
                          body: json.encode({
                            'email': email,
                    'name': name,
                    'phoneNumber': phonenumber,
                    'placeName': tourName,
                    'date': date,
                          }));
                  if (response2.statusCode == 200) {
                    final response3 = await http.post(
                        Uri.parse('${AppConfig.baseUrl}/submit3'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode({
                           'email': email,
                    'name': name,
                    'phoneNumber': phonenumber,
                    'placeName': tourName,
                    'date': date,
                        }));
                    if (response3.statusCode == 200) {
                      customShowDialog(context,'신청이 완료되었습니다. \n자세한 사항은 이메일을 확인해주세요.' );
                      
                    } else if (response3.statusCode == 500) {
                      customShowDialog(context, '이메일 주소를 다시 입력해주세요.');
                    } else {
                      customShowDialog(context, '서버 오류로 인해 신청에 실패했습니다.');
                    }
                  } else if (response2.statusCode == 300) {
                    customShowDialog(context, '이미 신청하셨습니다.');    
                  } else {
                    customShowDialog(context, '서버 오류로 인해 신청에 실패했습니다.');
                  }
                } else if (response.statusCode == 300) {
                  customShowDialog(context, '정원이 찼습니다.');
                } else {
                  customShowDialog(context, '서버 오류로 인해 신청에 실패했습니다.');
                }
              },
                      child: const Text(
                        '신청하기',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ), // 볼드체로 변경
                      ),
                    ),
                    
                  );
                  
                }
              },
            ),
          ),
          
        ],
      ),
    );
  }
}
