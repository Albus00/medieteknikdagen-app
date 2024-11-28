import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mtd_app/style/colors.dart';
import 'package:mtd_app/mainpage/category/eventscreen.dart';
import 'package:intl/intl.dart';
import 'package:mtd_app/models/schedule_model.dart';

// class EventsPreMTD {
//   final String title;
//   final String time;
//   final String date;
//   final String description;
//   Timestamp sorttime;
//   String descLong;
//   String image;
//   String url;
//   String urlNative;
//   String linkText;

//   EventsPreMTD({
//     required this.title,
//     this.time = "",
//     this.date = "",
//     this.description = "",
//     required this.sorttime,
//     this.descLong = "",
//     this.image = "",
//     this.url = "",
//     this.urlNative = "",
//     this.linkText = "",
//   });

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'time': time,
//         'date': date,
//         'description': description,
//         'sorttime': sorttime,
//         'descLong': descLong,
//         'image': image,
//         'url': url,
//         'urlNative': urlNative,
//         'linkText': linkText,
//       };

//   static EventsPreMTD fromJson(Map<String, dynamic> json) => EventsPreMTD(
//         title: json['title'],
//         time: json['time'],
//         date: json['date'],
//         description: json['description'],
//         sorttime: json['sorttime'],
//         descLong: json['descLong'],
//         image: json['image'],
//         url: json['url'],
//         urlNative: json['urlNative'],
//         linkText: json['linkText'],
//       );
// }

// Stream<List<Company>> readCompanyWelcome1() => FirebaseFirestore.instance
//     .collection("Companies")
//     .orderBy("isHuvudsponsor")
//     .snapshots()
//     .map((snapshot) =>
//         snapshot.docs.map((doc) => Company.fromJson(doc.data())).toList());

Future<List<Schedule>> readEventsFut() async {
  var events = await FirebaseFirestore.instance
      .collection("Schedule_2024")
      .orderBy("title")
      .get();

  return List<Schedule>.from(
      events.docs.map((doc) => Schedule.fromJson(doc.data())).toList());
}

//#region Old schedule and events code
// Stream<List<Schedule>> readSchedule() => FirebaseFirestore.instance
//     .collection("Schedule_2024")
//     .orderBy("date")
//     .snapshots()
//     .map((snapshot) =>
//         snapshot.docs.map((doc) => Schedule.fromJson(doc.data())).toList());

// Future<List<EventsPreMTD>> readEventsMTDFut() async {
//   var notifs = await FirebaseFirestore.instance
//       .collection("Events_preMTD2023")
//       .where("isMTD", isEqualTo: true)
//       .orderBy("sorttime")
//       .get();

//   return List<EventsPreMTD>.from(
//       notifs.docs.map((doc) => EventsPreMTD.fromJson(doc.data())).toList());
// }

// Future<List<EventsPreMTD>> readEventsPreMTDFut() async {
//   var notifs = await FirebaseFirestore.instance
//       .collection("Events_preMTD2023")
//       .orderBy("sorttime")
//       .get();

//   return List<EventsPreMTD>.from(
//       notifs.docs.map((doc) => EventsPreMTD.fromJson(doc.data())).toList());
// }
//#endregion

class TestFrame extends StatefulWidget {
  const TestFrame({super.key});

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
          // Container to display the title "Dagens Aktiviteter"
          const Text(
            'Dagens Aktiviteter',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mainColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            // FutureBuilder to fetch and display the list of events
            child: FutureBuilder<List<Schedule>>(
              future: readEventsFut(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // If there is an error, display a text widget with an error message
                  return Text(
                    "Something went wrong! ${snapshot.error}",
                    style: const TextStyle(color: Colors.white),
                  );
                }
                if (!snapshot.hasData) {
                  // If there is no data, display a circular progress indicator
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var eventsData = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: eventsData.length,
                  itemBuilder: (context, index) {
                    final currentEvent = eventsData[index];
                    String formattedEventDate =
                        DateFormat('d MMM').format(currentEvent.date.toDate());
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
                              date: DateFormat('d MMM')
                                  .format(currentEvent.date.toDate()),
                              description: currentEvent.description,
                              desc_long: currentEvent.desc_long,
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
                          // LayoutBuilder to display the date of the event
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (formattedEventDate == formattedDate) {
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
                                        DateFormat('d MMMM')
                                            .format(currentEvent.date.toDate()),
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
                          // LayoutBuilder to display the event details
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (formattedEventDate == formattedDate) {
                                return Container(
                                  width: 500,
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(
                                      top: 4, left: 30, right: 30, bottom: 4),
                                  decoration: BoxDecoration(
                                    color: backgroundVariantColor,
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 2,
                                                  bottom: 2),
                                              child: Text(
                                                currentEvent.time,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            currentEvent.description,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
