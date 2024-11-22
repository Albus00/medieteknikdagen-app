import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  String title;
  String time;
  Timestamp date;
  String description;
  String desc_long;
  String image;
  String url;
  String urlNative;
  String linkText;

  Schedule({
    this.title = "",
    this.time = "",
    required this.date,
    this.description = "",
    this.desc_long = "",
    this.image = "",
    this.url = "",
    this.urlNative = "",
    this.linkText = "",
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      title: json['title'] ?? "",
      time: json['time'] ?? "",
      date: json['date'],
      description: json['description'] ?? "",
      desc_long: json['desc_long'] ?? "",
      image: json['image'] ?? "",
      url: json['url'] ?? "",
      urlNative: json['urlNative'] ?? "",
      linkText: json['linkText'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'date': date,
      'description': description,
      'desc_long': desc_long,
      'image': image,
      'url': url,
      'urlNative': urlNative,
      'linkText': linkText,
    };
  }
}
