import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Tour.dart';
import 'DetailScreen.dart';
import 'config.dart';

class NewToursScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phonenumber;
  const NewToursScreen({super.key,
  required this.name,
  required this.email,
  required this.phonenumber});

  @override
  _NewToursScreenState createState() => _NewToursScreenState();
}

class _NewToursScreenState extends State<NewToursScreen> {
  List<Tour> tourNames = [];
  List<String> tourImagesBase64 = [];
 
  String name = ''; // 사용자 이름 변수 추가
  String email = ''; // 사용자 이메일 변수 추가
  String phonenumber = ''; // 사용자 전화번호 변수 추가

  @override
  void initState() {
    super.initState();
    name = widget.name; // 사용자 이름 설정
    email = widget.email; // 사용자 이메일 설정
    phonenumber = widget.phonenumber; // 사용자 전화번호 설정
    fetchTours(); // 투어 목록 가져오기
  }

  Future<void> fetchTours() async {
    // 서버에서 투어 리스트를 받아옵니다.
    final tourResponse = await http.post(
      Uri.parse('${AppConfig.baseUrl}/new_list'),
      //Uri.parse('https://uyserver.ngrok.io/new_list'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'jin': "hello jinwoo"}),
    );

    if (tourResponse.statusCode == 200) {
      final responseData = json.decode(tourResponse.body)['results'];
      final List<Tour> tours =
          responseData.map<Tour>((json) => Tour.fromJson(json)).toList();

      setState(() {
        tourNames = tours;
      });
      // 투어의 길이를 서버로 보내고 사진을 받아옵니다.
      await fetchTourImages(tours.length);
    } else {
      // 오류 처리
      print('Error: ${tourResponse.statusCode}');
      print('Error body: ${tourResponse.body}');
      throw Exception('Failed to load tours');
    }
  }

  Future<void> fetchTourImages(int length) async {
    final photoResponse = await http.post(
      Uri.parse('${AppConfig.baseUrl}/new_image'),
      //Uri.parse('https://uyserver.ngrok.io/new_image'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'length': length}),
    );

    if (photoResponse.statusCode == 200) {
      final List<dynamic> imageUrls = json.decode(photoResponse.body)['images'];
      setState(() {
        tourImagesBase64 = imageUrls.cast<String>();
      });
    } else {
      // 오류 처리
      print('Error: ${photoResponse.statusCode}');
      print('Error body: ${photoResponse.body}');
      throw Exception('Failed to load tour images');
    }
  }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '모집 중',
          
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // 제목 텍스트 색상을 검은색으로 변경
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 102, 133, 159), // AppBar의 배경색을 skyblue로 변경
      ),
      body: ListView.builder(
        itemCount: tourNames.length,
        itemBuilder: (context, index) {
          final tour = tourNames[index];
          final imageBase64 =
              tourImagesBase64.isNotEmpty ? tourImagesBase64[index] : null;

          // base64 문자열에서 'data:image/jpeg;base64,' 접두어를 제거하고 디코딩합니다.
          Widget imageWidget;
          if (imageBase64 != null) {
            final base64String =
                imageBase64.substring('data:image/jpeg;base64,'.length);
            final imageBytes = base64Decode(base64String);
            imageWidget = Image.memory(imageBytes);
          } else {
            // 이미지가 없을 때의 placeholder
            imageWidget = Image.asset('assets/placeholder.png');
          }

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10.0),
                  width: 130,
                  height: 200,
                  child: imageWidget, // 디코딩된 이미지를 표시합니다.
                ),
                // 중앙에 세부 정보를 표시합니다.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tour.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, // 이름을 볼드체로 표시합니다.
                            fontSize: 20,
                          ),
                        ),
                        Text('날짜: ${tour.date}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text('모집 인원: ${tour.peopleWant}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Text('참여 인원: ${tour.peopleReal}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          onPressed: () async {
                            // '후기 보기' 버튼 클릭 시 실행할 동작 추가
                            final tourName = tour.name;
                            final response = await http.post(
                              Uri.parse('${AppConfig.baseUrl}/tour_detail'),
                              //Uri.parse(
                              //'https://uyserver.ngrok.io/tour_detail'),
                              headers: {'Content-Type': 'application/json'},
                              body: json.encode({'place': tourName}),
                            );

                            if (response.statusCode == 200) {
                              final Map<String, dynamic> responseData =
                                  json.decode(response.body);
                              final List<dynamic> reviewList =
                                  responseData['review'];

                              // reviewList를 활용하여 후기 목록을 표시
                              List<String> reviews = reviewList
                                  .map((review) => review['review'] as String)
                                  .toList();

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  tourName: tour.name,
                                  reviews: reviews,
                                  date: tour.date, // 추가: 날짜 전달
                                  peopleWant: tour.peopleWant, // 추가: 모집 인원 전달
                                  peopleReal: tour.peopleReal, // 추가: 참여 인원 전달
                                  imageWidget: imageWidget, // 추가: 이미지 위젯 전달
                                  name: name, email: email, phonenumber: phonenumber
                                ),
                              ));
                            } else {
                              // 오류 처리
                              print('Error: ${response.statusCode}');
                              print('Error body: ${response.body}');
                              throw Exception('Failed to load reviews');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 128, 153, 173),
                                width: 2), // 테두리 설정
                          ),
                          child: const Text(
                            '신청하기',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold // 텍스트 색상을 검은색으로 변경
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
