// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mtd_app/mainpage/category/eventscreen.dart';
import 'package:mtd_app/style/colors.dart';

//För MTD

//för preMTD
// ignore: camel_case_types
class Events_preMTD {
  String title;
  String time;
  Timestamp date;
  String description;
  String desc_long;
  String image;
  String url;
  String urlNative;
  String link_text;

  Events_preMTD({
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

  factory Events_preMTD.fromJson(Map<String, dynamic> json) {
    return Events_preMTD(
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

Stream<List<Events_preMTD>> readEvents_preMTD() => FirebaseFirestore.instance
    .collection("Events_preMTD2023")
    .where("isPreMTD", isEqualTo: true)
    .orderBy("sorttime")
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Events_preMTD.fromJson(doc.data()))
        .toList());

Stream<List<Events_preMTD>> readEvents_MTD() => FirebaseFirestore.instance
    .collection("Events_preMTD2023")
    .where("isMTD", isEqualTo: true)
    .orderBy("sorttime")
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Events_preMTD.fromJson(doc.data()))
        .toList());

Future<List> readEvents_MTD_fut() async {
  var notifs = await FirebaseFirestore.instance
      .collection("Events_preMTD2023")
      .where("isMTD", isEqualTo: true)
      .orderBy("sorttime")
      .get();

  return List<Events_preMTD>.from(
      notifs.docs.map((doc) => Events_preMTD.fromJson(doc.data())).toList());
}

Future<List> readEvents_preMTD_fut() async {
  var notifs = await FirebaseFirestore.instance
      .collection("Events_preMTD2023")
      .where("isPreMTD", isEqualTo: true)
      .orderBy("sorttime")
      .get();

  return List<Events_preMTD>.from(
      notifs.docs.map((doc) => Events_preMTD.fromJson(doc.data())).toList());
}

// Future<Map> getSomething(String docId) async {
//     CollectionReference campRef = FirebaseFirestore.instance.collection("Events_preMTD");
//     return await campRef.doc(docId).get().then((value) => value.data());
// }

class Event extends StatefulWidget {
  const Event({super.key});

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  //Stream<List<Events_preMTD>> setEvent = readEvents_preMTD();
  Future<List> setEvent = readEvents_preMTD_fut();

  Color mtd_color = backgroundColor;
  Color premtd_color = mainColor;

  String rubrik = "PreMTD";

  //int _counter = 0;

  List veckan = ["Måndag", "Tisdag", "Onsdag", "Torsdag", "Fredag", "Måndag"];

  // bool checker1 = true;
  // bool checker2 = true;
  // bool checker3 = true;
  // bool checker4 = true;
  // bool checker5 = true;
  // bool checker6 = true;
  // bool checker7 = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 8,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              child: FutureBuilder<List>(
                  future: setEvent,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Something went wrong!   '); //${snapshot.error}
                    } else if (snapshot.hasData) {
                      var eventsDates = snapshot.data!;
                      var eventsData = snapshot.data!;

                      eventsDates = eventsDates
                          .map((element) {
                            return element.date;
                          })
                          .toSet()
                          .toList();
                      return ListView(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: mainColor, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: premtd_color,
                                    ),
                                    child: const Text(
                                      'PreMTD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      setEvent = readEvents_preMTD_fut();
                                      premtd_color = mainColor;
                                      mtd_color = backgroundColor;
                                      rubrik = "PreMTD";
                                    });
                                  }),
                              InkWell(
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: mainColor, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                      color: mtd_color,
                                      //color: Colors.black,
                                    ),
                                    child: const Text(
                                      'MTD',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      setEvent = readEvents_MTD_fut();
                                      premtd_color = backgroundColor;
                                      mtd_color = mainColor;
                                      rubrik = "Mässdagen";
                                    });
                                  }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: eventsData.length,
                              itemBuilder: (context, index) {
                                final currentEvent = eventsData[index];
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventScreen(
                                            title: currentEvent.title,
                                            time: currentEvent.time,
                                            date: DateFormat('d MMM').format(
                                                currentEvent.date.toDate()),
                                            description:
                                                currentEvent.description,
                                            desc_long: currentEvent.desc_long,
                                            image: currentEvent.image,
                                            url: currentEvent.url,
                                            urlNative: currentEvent.url,
                                            link_text: currentEvent.link_text,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            if (index != 0 &&
                                                eventsData[index].date ==
                                                    eventsData[index - 1]
                                                        .date) {
                                              return const Text(' ');
                                            }

                                            return (Container(
                                              margin: const EdgeInsets.only(
                                                top: 4,
                                                left: 32,
                                                bottom: 5,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    rubrik == "PreMTD"
                                                        ? DateFormat('d MMMM')
                                                            .format(currentEvent
                                                                .date
                                                                .toDate())
                                                        : "",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          rubrik == "PreMTD"
                                                              ? 20
                                                              : 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                          },
                                        ),
                                        Container(
                                            //Detta är container för varje objekt
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 4,
                                                left: 30,
                                                right: 30,
                                                bottom: 4),
                                            decoration: BoxDecoration(
                                              color: backgroundVariantColor,
                                              borderRadius:
                                                  BorderRadius.circular(13),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: const Color.fromARGB(
                                                            255, 0, 0, 0)
                                                        .withOpacity(0.3),
                                                    spreadRadius: 1,
                                                    blurRadius: 6,
                                                    offset: const Offset(3, 5)),
                                              ],
                                              //color: mainColor,
                                            ),
                                            child: LayoutBuilder(builder:
                                                (context, constraints) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Text(
                                                        currentEvent.title,
                                                        style: const TextStyle(
                                                          fontSize: 22,
                                                          color: mainColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: mainColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 2,
                                                                    bottom: 2),
                                                            child: Text(
                                                              currentEvent.time,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        currentEvent
                                                            .description,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })),
                                      ],
                                    ));
                              }),
                        )
                      ]);
                    } else {
                      return const Text('Loading...');
                    }
                  }))
        ]));
  }
}
