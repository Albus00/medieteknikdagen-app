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
  String link_text;

  Schedule({
    this.title = "",
    this.time = "",
    required this.date,
    this.description = "",
    this.desc_long = "",
    this.image = "",
    this.url = "",
    this.urlNative = "",
    this.link_text = "",
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
      link_text: json['link_text'] ?? "",
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
      'link_text': link_text,
    };
  }
}
