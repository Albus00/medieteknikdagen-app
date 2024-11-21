import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mtd_app/mainpage/notificationscreen.dart';

class Notification {
  final String title;
  final String description;
  String linktitle;
  String link;
  String image;
  String url;

  String urlNative;
  //Timestamp sorttime;

  Notification({
    required this.title,
    required this.description,
    this.linktitle = '',
    this.link = '',
    this.image = '',
    this.url = '',
    this.urlNative = '',
    // required this.sorttime,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'linktitle': linktitle,
        'link': link,
        'image': image,
        'url': url,
        'url_native': urlNative,
        //  'sorttime': sorttime,
      };

  static Notification fromJson(Map<String, dynamic> json) => Notification(
        title: json['title'],
        description: json['description'],
        linktitle: json['link_text'],
        link: json['bottom_text'],
        image: json['image'],
        url: json['url'],
        urlNative: json['url_native'],
        //  sorttime: json['sorttime'],
      );
}

Stream<List<Notification>> readNotificationStream() => FirebaseFirestore
    .instance
    .collection("Notifications2023")
    .orderBy("sorttime", descending: true)
    .snapshots(includeMetadataChanges: true)
    .map((snapshot) =>
        snapshot.docs.map((doc) => Notification.fromJson(doc.data())).toList());

Future<List> readNotificationFut() async {
  var notifs = await FirebaseFirestore.instance
      .collection("Notifications2023")
      .orderBy("sorttime", descending: true)
      .get();

  return List<Notification>.from(
      notifs.docs.map((doc) => Notification.fromJson(doc.data())).toList());
}

Widget buildNotification(Notification notification) => Container(
      alignment: Alignment.center,
      color: Colors.grey.withOpacity(0.2),
      child: Text(notification.title),
    );

class PostFeed extends StatefulWidget {
  const PostFeed({super.key});

  @override
  State<PostFeed> createState() => _PostFeedViewer();
}

class _PostFeedViewer extends State<PostFeed> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: const Color.fromARGB(255, 19, 41, 61),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //HÄR ÄR FLÖDET
          Expanded(
              //HERE CHANGE THIS EXPANDED TO CONTAINER, WHEN I TRY IT DOENST WORK
              flex: 6,
              child: StreamBuilder<List>(
                  stream: readNotificationStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Something went wrong!  '); //${snapshot.error}
                    } else if (snapshot.hasData) {
                      final notificationsData = snapshot.data!;
                      bool titleHasRendered = false;

                      return ListView.builder(
                        reverse: false,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final currentNotif = notificationsData[index];

                          // if (!titleHasRendered) {
                          //   titleHasRendered = true;
                          //   index = 2;
                          //   return Text(
                          //     'Nyheter',
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.w900,
                          //       fontSize: 30,
                          //     ),
                          //   );
                          // }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(
                                    image: currentNotif.image,
                                    title: currentNotif.title,
                                    description: currentNotif.description,
                                    link: currentNotif.link,
                                    linktitle: currentNotif.linktitle,
                                    url: currentNotif.url,
                                    urlNative: currentNotif.urlNative,
                                    //   sorttime: currentNotif.sorttime,
                                  ),
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.all(20),
                                width: 360,
                                height: 200,
                                decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(10, 10),
                                        blurRadius: 10),
                                  ],
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        currentNotif.image),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentNotif.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          currentNotif.link,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text('Loading...');
                    }
                  })),
        ],
      ),
    ));
  }
}

int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
