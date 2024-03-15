// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'config.dart';

// class ApplyTourScreen extends StatefulWidget {
//   final String placeName;
//   final String date;
//   final String name;
//   final String email;
//   final String phonenumber;

//   const ApplyTourScreen({super.key, required this.placeName, required this.date,
//   required this.name,
//   required this.email,
//   required this.phonenumber});

//   @override
//   _ApplyTourScreenState createState() => _ApplyTourScreenState();
// }

// class _ApplyTourScreenState extends State<ApplyTourScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   String responseMessage = '';

//   String selectedEmailDomain = '@gmail.com';
//   String name2 = ''; // 사용자 이름 변수 추가
//   String email2 = ''; // 사용자 이메일 변수 추가
//   String phonenumber2 = ''; // 사용자 전화번호 변수 추가

//   @override
//   void initState() {
//     super.initState();
//     name2 = widget.name; // 사용자 이름 설정
//     email2 = widget.email; // 사용자 이메일 설정
//     phonenumber2 = widget.phonenumber; // 사용자 전화번호 설정
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text(
//           '투어 신청하기',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: const Color.fromARGB(255, 102, 133, 159),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               '투어 장소: ${widget.placeName}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     child: TextField(
//                       controller: emailController,
//                       decoration: const InputDecoration(
//                         labelText: '이메일',
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black, width: 2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 2),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.4,
//                   child: DropdownButton<String>(
//                     value: selectedEmailDomain,
//                     items: [
//                       '@gmail.com',
//                       '@naver.com',
//                       '@hanyang.ac.kr',
//                       '@hanmail.net'
//                     ].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(
//                           value,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (newValue) {
//                       setState(() {
//                         selectedEmailDomain = newValue!;
//                       });
//                     },
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     dropdownColor: Colors.white,
//                     icon: const Icon(
//                       Icons.arrow_drop_down,
//                       color: Colors.black,
//                     ),
//                     underline: Container(
//                       height: 0,
//                       color: const Color.fromARGB(255, 102, 157, 159),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: '이름',
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black, width: 2),
//                 ),
//               ),
//             ),
//             TextField(
//               controller: phoneNumberController,
//               decoration: const InputDecoration(
//                 labelText: '전화번호',
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.black, width: 2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 side: const BorderSide(color: Colors.black, width: 2),
//               ),
//               onPressed: () async {
//                 final email = emailController.text + selectedEmailDomain;
//                 final name = nameController.text;
//                 final phoneNumber = phoneNumberController.text;
//                 final placeName = widget.placeName;
//                 final date = widget.date;

//                 final response = await http.post(
//                   Uri.parse('${AppConfig.baseUrl}/submit1'),
//                   headers: {'Content-Type': 'application/json'},
//                   body: json.encode({
//                     'email': email2,
//                     'name': name2,
//                     'phoneNumber': phonenumber2,
//                     'placeName': placeName,
//                     'date': date,
//                   }),
//                 );

//                 if (response.statusCode == 200) {
//                   final response2 =
//                       await http.post(Uri.parse('${AppConfig.baseUrl}/submit2'),
//                           headers: {'Content-Type': 'application/json'},
//                           body: json.encode({
//                             'email': email2,
//                     'name': name2,
//                     'phoneNumber': phonenumber2,
//                             'placeName': placeName,
//                             'date': date,
//                           }));
//                   if (response2.statusCode == 200) {
//                     final response3 = await http.post(
//                         Uri.parse('${AppConfig.baseUrl}/submit3'),
//                         headers: {'Content-Type': 'application/json'},
//                         body: json.encode({
//                            'email': email2,
//                     'name': name2,
//                     'phoneNumber': phonenumber2,
//                           'placeName': placeName,
//                           'date': date,
//                         }));
//                     if (response3.statusCode == 200) {
//                       setState(() {
//                         responseMessage = '신청이 완료되었습니다. 자세한 사항은 이메일을 확인해주세요.';
//                       });
//                     } else if (response3.statusCode == 500) {
//                       setState(() {
//                         responseMessage = '이메일 주소를 다시 입력해주세요.';
//                       });
//                     } else {
//                       setState(() {
//                         responseMessage = '서버 오류로 인해 신청에 실패했습니다.';
//                       });
//                     }
//                   } else if (response2.statusCode == 300) {
//                     setState(() {
//                       responseMessage = '이미 신청하셨습니다.';
//                     });
//                   } else {
//                     setState(() {
//                       responseMessage = '서버 오류로 인해 신청에 실패했습니다.';
//                     });
//                   }
//                 } else if (response.statusCode == 300) {
//                   setState(() {
//                     responseMessage = '신청 정원이 찼습니다.';
//                   });
//                 } else {
//                   setState(() {
//                     responseMessage = '서버 오류로 인해 신청에 실패했습니다.';
//                   });
//                 }
//               },
//               child: const Text(
//                 '신청',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               responseMessage,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
