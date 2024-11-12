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

class Events_preMTD {
  final String title;
  final String time;
  final String date;
  final String description;
  Timestamp sorttime;
  // ignore: non_constant_identifier_names
  String desc_long;
  String image;
  String url;
  // ignore: non_constant_identifier_names
  String url_native;
  // ignore: non_constant_identifier_names
  String link_text;

  Events_preMTD({
    required this.title,
    this.time = "",
    this.date = "",
    this.description = "",
    required this.sorttime,
    // ignore: non_constant_identifier_names
    this.desc_long = "",
    this.image = "",
    this.url = "",
    // ignore: non_constant_identifier_names
    this.url_native = "",
    // ignore: non_constant_identifier_names
    this.link_text = "",
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'time': time,
        'date': date,
        'description': description,
        'sorttime': sorttime,
        'desc_long': desc_long,
        'image': image,
        'url': url,
        'url_native': url_native,
        'link_text': link_text,
      };

  static Events_preMTD fromJson(Map<String, dynamic> json) => Events_preMTD(
        title: json['title'],
        time: json['time'],
        date: json['date'],
        description: json['description'],
        sorttime: json['sorttime'],
        desc_long: json['desc_long'],
        image: json['image'],
        url: json['url'],
        url_native: json['url_native'],
        link_text: json['link_text'],
      );
}

Stream<List<Company>> readCompanyWelcome1() => FirebaseFirestore.instance
    .collection("Companies")
    .orderBy("isHuvudsponsor")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Company.fromJson(doc.data())).toList());

Future<List> readEventsMTDFut() async {
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
      //.where("isPreMTD", isEqualTo: true)
      .orderBy("sorttime")
      .get();

  return List<Events_preMTD>.from(
      notifs.docs.map((doc) => Events_preMTD.fromJson(doc.data())).toList());
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
      //child: Center(
      child: Column(
        //mainAxisSize: MainAxisSize.min
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 10.0, bottom: 0.0),
            child: Container(
                //padding:
                //  const EdgeInsets.only(left: , top: 5, right: 30, bottom: 10),

                width: 340,
                height: 260,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  //color: const Color.fromARGB(255, 236, 246, 255),
                  color: const Color.fromARGB(255, 19, 41, 61),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ignore: prefer_const_constructors
                    const Text(
                      'MTD VILL UTBRINGA ETT STORT TACK TILL VÅR HUVUDSPONSOR!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          //color: Color.fromARGB(255, 236, 102, 17),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Expanded(
                        child: Center(
                      child: StreamBuilder<List<Company>>(
                          stream: readCompanyWelcome1(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text(
                                  'Something went wrong!  '); //${snapshot.error}
                            } else if (snapshot.hasData) {
                              var companyss = snapshot.data!;

                              companyss.shuffle();

                              return Center(
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                      left: 30, top: 0, right: 30, bottom: 30),
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 150,
                                          childAspectRatio: 4 / 2,
                                          crossAxisSpacing: 20,
                                          mainAxisSpacing: 20),
                                  itemCount:
                                      companyss.length, //snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final currentComp = companyss[index];

                                    return GestureDetector(onTap: () {
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
                                    }, child: Center(
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        if (currentComp.image == "") {
                                          return Container(
                                              alignment: Alignment.center,
                                              // color: Colors.grey.withOpacity(0.2),
                                              child: const Text("hej",
                                                  style:
                                                      TextStyle(fontSize: 12)));
                                        } else {
                                          return Container(
                                              decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  currentComp.image),
                                              //fit: BoxFit.cover,
                                            ),
                                          ));
                                        }
                                      }),
                                    ));
                                  },
                                ),
                              );
                            } else {
                              return const Text('Loading...');
                            }
                          }),
                    )),
                  ],
                )),
          ),
          Container(
            padding: const EdgeInsets.only(left: 31.0),
            color: backgroundColor,
            width: double.infinity,
            child: const Text(
              'Dagens Aktiviteter',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: mainColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
              //fit: FlexFit.loose,
              child: FutureBuilder<List>(
                  future: readEvents_preMTD_fut(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Something went wrong!   '); //${snapshot.error}
                    } else if (snapshot.hasData) {
                      var eventsDates = snapshot.data!;
                      var eventsData = snapshot.data!;
                      // Map<int, List> result =
                      //     groupBy(eventsData, (id) => id.date);

                      // Map<String, List> resrult = eventsData.where((element) {
                      //   return element.date.toString().contains("28 Nov");
                      // }) as Map<String, List>;

                      eventsDates = eventsDates
                          .map((element) {
                            return element.date;
                          })
                          .toSet()
                          .toList();

                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: eventsData.length,
                          itemBuilder: (context, index) {
                            final currentEvent = eventsData[index];
                            //print(index);
                            // FIXA DATE HÄR
                            DateTime todayDate = DateTime.now();
                            String formattedDate =
                                DateFormat('d MMM').format(todayDate);
                            //print(formattedDate);

                            // List hall = eventsData[index].contains("date");
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
                                        descLong: currentEvent.desc_long,
                                        image: currentEvent.image,
                                        url: currentEvent.url,
                                        urlNative: currentEvent.url_native,
                                        linkText: currentEvent.link_text,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        //var result = lastEvent.date.compareTo(currentEvent.date);
                                        if (eventsData[index].date ==
                                            formattedDate) {
                                          //print(eventsData[index].date);
                                          if (index != 0 &&
                                              eventsData[index].date ==
                                                  eventsData[index - 1].date) {
                                            return const Text(' ');
                                          }

                                          //lastDate = currentEvent.date;
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
                                                  currentEvent.date,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                    LayoutBuilder(
                                        builder: (context, constraints) {
                                      if (eventsData[index].date ==
                                          formattedDate) {
                                        return Container(
                                            //Detta är container för varje objekt
                                            width: 500,
                                            padding: const EdgeInsets.all(10),
                                            margin: const EdgeInsets.only(
                                                top: 4,
                                                left: 30,
                                                right: 30,
                                                bottom: 4),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 39, 56, 72),
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
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5),
                                                    child: Text(
                                                      //Här är titeln
                                                      currentEvent.title,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: mainColor,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              );
                                            }));
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    })
                                    //else
                                    //const Text(" "),
                                  ],
                                ));
                          });
                    } else {
                      return const Text('Loading...');
                    }
                  })),
        ],
      ),
      //),
    );

    //  flex: 8,
    //  child: Column(
    //    mainAxisSize: MainAxisSize.min,
    //    children: [
    //    Column(
    //      crossAxisAlignment: CrossAxisAlignment.center,
    //      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //      children: [
    //        //InkWell(
    //        //    child: Container(
    //        //      width: 110,
    //        //      decoration: BoxDecoration(
    //        //        border: Border.all(color: mainColor, width: 2),
    //        //        borderRadius: BorderRadius.circular(10),
    //        //        color: Colors.white,
    //        //      ),
    //        //      child: const Text(
    //        //        'PreMTD',
    //        //        textAlign: TextAlign.center,
    //        //        style: TextStyle(
    //        //          fontWeight: FontWeight.w900,
    //        //          fontSize: 15,
    //        //        ),
    //        //      ),
    //        //    ),
    //        //),
    //        InkWell(
    //            child: Container(
    //              //padding:
    //              //  const EdgeInsets.only(left: 30, top: 5, right: 30, bottom: 10),
    //              width: 330,
    //              height: double.infinity,
    //              alignment: Alignment.center,
    //              decoration: BoxDecoration(
    //                borderRadius: BorderRadius.circular(10),
    //                color: const Color.fromARGB(255, 37, 149, 255),
    //                //color: const Color.fromARGB(255, 19, 41, 61),
    //              ),
    //              child: const Column(
    //                mainAxisAlignment: MainAxisAlignment.center,
    //
    //                children: [
    //                Icon(
    //                  MyFlutterApp.mtd_svart,
    //                  color: mainColor,
    //                  size: 80,
    //                ),
    //                Text(
    //                  'MTD vill utbringa ett stort tack till våra huvudsponsorer',
    //                  textAlign: TextAlign.center,
    //                  style: TextStyle(
    //                    color: Colors.white,
    //                    fontWeight: FontWeight.bold,
    //                    fontSize: 14),
    //                ),
    //              ])
//
    //            ),
    //        )
    //      ]
    //    )
    //  ]
    //)
    //);

    //   return Scaffold(
    //    appBar: AppBar(
    //      title: Text('Hello Flutter'),
    //    ),
    //    body: Center(
    //      child: Text(
    //        'HI',
    //        style: TextStyle(fontSize: 24),
    //      ),
    //    ),
    //  );
    //}
  }
}
