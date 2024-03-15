import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Tour.dart';
import 'TourReviewScreen.dart';
import 'config.dart';

class PastToursScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phonenumber;
  const PastToursScreen({super.key,
  required this.name,
  required this.email,
  required this.phonenumber});

  @override
  _PastToursScreenState createState() => _PastToursScreenState();
}

class _PastToursScreenState extends State<PastToursScreen> {
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
    fetchTours();
  }

  Future<void> fetchTours() async {
    final tourResponse = await http.post(
      Uri.parse('${AppConfig.baseUrl}/past_list'),
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

      await fetchTourImages(tours.length);
    } else {
      print('Error: ${tourResponse.statusCode}');
      print('Error body: ${tourResponse.body}');
      throw Exception('Failed to load tours');
    }
  }

  Future<void> fetchTourImages(int length) async {
    final photoResponse = await http.post(
      Uri.parse('${AppConfig.baseUrl}/past_image'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'length': length}),
    );

    if (photoResponse.statusCode == 200) {
      final List<dynamic> imageUrls = json.decode(photoResponse.body)['images'];
      setState(() {
        tourImagesBase64 = imageUrls.cast<String>();
      });
    } else {
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
        title: const Text(
          '지난 투어',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 102, 133, 159),
      ),
      body: ListView.builder(
        itemCount: tourNames.length,
        itemBuilder: (context, index) {
          final tour = tourNames[index];
          final imageBase64 =
              tourImagesBase64.isNotEmpty ? tourImagesBase64[index] : null;

          Widget imageWidget;
          if (imageBase64 != null) {
            final base64String =
                imageBase64.substring('data:image/jpeg;base64,'.length);
            final imageBytes = base64Decode(base64String);
            imageWidget = Image.memory(imageBytes);
          } else {
            imageWidget = Image.asset('assets/placeholder.png');
          }

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    width: 130,
                    height: 200,
                    child: imageWidget,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tour.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '날짜: ${tour.date}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '모집 인원: ${tour.peopleWant}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '참여 인원: ${tour.peopleReal}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final tourName = tour.name;
                              final response = await http.post(
                                Uri.parse('${AppConfig.baseUrl}/past_review'),
                                headers: {'Content-Type': 'application/json'},
                                body: json.encode({'place': tourName}),
                              );

                              if (response.statusCode == 200) {
                                final Map<String, dynamic> responseData =
                                    json.decode(response.body);
                                final List<dynamic> reviewList =
                                    responseData['review'];

                                List<String> reviews = reviewList
                                    .map((review) => review['review'] as String)
                                    .toList();

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TourReviewScreen(
                                    tourName: tour.name,
                                    reviews: reviews,
                                    date: tour.date,
                                    peopleWant: tour.peopleWant,
                                    peopleReal: tour.peopleReal,
                                    imageWidget: imageWidget,
                                    name: name, email: email, phonenumber: phonenumber
                                  ),
                                ));
                              } else {
                                print('Error: ${response.statusCode}');
                                print('Error body: ${response.body}');
                                throw Exception('Failed to load reviews');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: Color.fromARGB(255, 128, 153, 173),
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              '후기 작성',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
