import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'WriteReview.dart';

class TourReviewScreen extends StatelessWidget {
  final String tourName;
  final List<String> reviews;
  final String date;
  final int peopleWant;
  final int peopleReal;
  final Widget imageWidget;
  final String name;
  final String email;
  final String phonenumber;

  const TourReviewScreen({super.key, 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '투어 후기 - $tourName',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 102, 133, 159),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 110,
                  width: 140,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageWidget,
                  ),
                ),
                const SizedBox(width: 10),
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
                      Text('참여 인원: $peopleReal',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      // '후기 작성' 버튼 추가
                      const SizedBox(height: 10), // 버튼과 텍스트 사이의 거리를 조정
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ), backgroundColor: const Color.fromARGB(255, 102, 133, 159), // 버튼 배경색 설정
                        ),
                        onPressed: () {
// Add your code here to handle the '후기 작성' button press
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    WriteReview(placeName: tourName , name: name, email: email, phonenumber: phonenumber)),
                          );
                        },
                        child: const Text(
                          '후기 작성',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white, // 텍스트 색상 설정
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      reviews[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  ),
                );
              },
            ),
          ),
          // Add the '후기 작성' button below the review list
        ],
      ),
    );
  }
}
