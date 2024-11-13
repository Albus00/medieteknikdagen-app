import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mtd_app/style/colors.dart';
import '../icons/custom_app_icons.dart';
import 'package:mtd_app/mainpage/companyscreen.dart';
import 'package:mtd_app/models/companies_firebase.dart';
import 'package:mtd_app/mainpage/category/eventscreen.dart';
import 'package:intl/intl.dart';

class EventsPreMTD {
  final String title;
  final String time;
  final String date;
  final String description;
  Timestamp sorttime;
  String descLong;
  String image;
  String url;
  String urlNative;
  String linkText;

  EventsPreMTD({
    required this.title,
    this.time = "",
    this.date = "",
    this.description = "",
    required this.sorttime,
    this.descLong = "",
    this.image = "",
    this.url = "",
    this.urlNative = "",
    this.linkText = "",
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'time': time,
        'date': date,
        'description': description,
        'sorttime': sorttime,
        'descLong': descLong,
        'image': image,
        'url': url,
        'urlNative': urlNative,
        'linkText': linkText,
      };

  static EventsPreMTD fromJson(Map<String, dynamic> json) => EventsPreMTD(
        title: json['title'],
        time: json['time'],
        date: json['date'],
        description: json['description'],
        sorttime: json['sorttime'],
        descLong: json['descLong'],
        image: json['image'],
        url: json['url'],
        urlNative: json['urlNative'],
        linkText: json['linkText'],
      );
}

Stream<List<Company>> readCompanyWelcome1() => FirebaseFirestore.instance
    .collection("Companies")
    .orderBy("isHuvudsponsor")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Company.fromJson(doc.data())).toList());

Future<List<EventsPreMTD>> readEventsMTDFut() async {
  var notifs = await FirebaseFirestore.instance
      .collection("Events_preMTD2023")
      .where("isMTD", isEqualTo: true)
      .orderBy("sorttime")
      .get();

  return List<EventsPreMTD>.from(
      notifs.docs.map((doc) => EventsPreMTD.fromJson(doc.data())).toList());
}

Future<List<EventsPreMTD>> readEventsPreMTDFut() async {
  var notifs = await FirebaseFirestore.instance
      .collection("Events_preMTD2023")
      .orderBy("sorttime")
      .get();

  return List<EventsPreMTD>.from(
      notifs.docs.map((doc) => EventsPreMTD.fromJson(doc.data())).toList());
}

class TestFrame extends StatefulWidget {
  const TestFrame({Key? key}) : super(key: key);

  @override
  State<TestFrame> createState() => _TestFrameViewer();
}

class _TestFrameViewer extends State<TestFrame> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 10.0, bottom: 0.0),
            child: Container(
              width: 340,
              height: 260,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 19, 41, 61),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text widget to display a thank you message to the main sponsor
                  const Text(
                    'MTD VILL UTBRINGA ETT STORT TACK TILL VÅR HUVUDSPONSOR!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      // StreamBuilder to fetch and display the list of companies
                      child: StreamBuilder<List<Company>>(
                        stream: readCompanyWelcome1(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong!');
                          } else if (snapshot.hasData) {
                            var companies = snapshot.data!;
                            companies.shuffle();

                            return Center(
                              // GridView to display the companies in a grid format
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                    left: 30, top: 0, right: 30, bottom: 30),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150,
                                  childAspectRatio: 4 / 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: companies.length,
                                itemBuilder: (context, index) {
                                  final currentComp = companies[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CompanyScreen(
                                            image: currentComp.image,
                                            name: currentComp.name,
                                            description:
                                                currentComp.description,
                                            hasExjobb: currentComp.hasExjobb,
                                            hasSommarjobb:
                                                currentComp.hasSommarjobb,
                                            hasPraktik: currentComp.hasPraktik,
                                            hasTrainee: currentComp.hasTrainee,
                                            hasJobb: currentComp.hasJobb,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          if (currentComp.image == "") {
                                            return Container(
                                              alignment: Alignment.center,
                                              child: const Text(
                                                "hej",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      CachedNetworkImageProvider(
                                                          currentComp.image),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Text('Loading...');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container to display the title "Dagens Aktiviteter"
          Container(
            padding: const EdgeInsets.only(left: 31.0),
            color: backgroundColor,
            width: double.infinity,
            child: const Text(
              'Dagens Aktiviteter',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: mainColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            // FutureBuilder to fetch and display the list of events
            child: FutureBuilder<List<EventsPreMTD>>(
              future: readEventsPreMTDFut(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.data[0].title);
                } else if (snapshot.hasData) {
                  var eventsData = snapshot.data!;
                  var eventsDates = eventsData
                      .map((element) => element.date)
                      .toSet()
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: eventsData.length,
                    itemBuilder: (context, index) {
                      final currentEvent = eventsData[index];
                      DateTime todayDate = DateTime.now();
                      String formattedDate =
                          DateFormat('d MMM').format(todayDate);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventScreen(
                                title: currentEvent.title,
                                time: currentEvent.time,
                                date: currentEvent.date,
                                description: currentEvent.description,
                                descLong: currentEvent.descLong,
                                image: currentEvent.image,
                                url: currentEvent.url,
                                urlNative: currentEvent.urlNative,
                                linkText: currentEvent.linkText,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (eventsData[index].date == formattedDate) {
                                  if (index != 0 &&
                                      eventsData[index].date ==
                                          eventsData[index - 1].date) {
                                    return const Text(' ');
                                  }

                                  return Container(
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
                                          currentEvent.date,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (eventsData[index].date == formattedDate) {
                                  return Container(
                                    width: 500,
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        top: 4, left: 30, right: 30, bottom: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 39, 56, 72),
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 6,
                                          offset: const Offset(3, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            currentEvent.title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: mainColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          currentEvent.description,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          currentEvent.time,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('Loading...');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
