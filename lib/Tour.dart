class Tour {
  final int sequenceNumber;
  final String name;
  final String date;
  final int peopleWant;
  final int peopleReal;

  Tour({
    required this.sequenceNumber,
    required this.name,
    required this.date,
    required this.peopleWant,
    required this.peopleReal,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      sequenceNumber: json['Sequence_Number'],
      name: json['Name'],
      date: json['Date'],
      peopleWant: json['People_want'],
      peopleReal: json['People_Real'],
    );
  }
}
