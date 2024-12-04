import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:mtd_app/style/colors.dart';
import 'package:url_launcher/url_launcher_string.dart';
// import '../../icons/custom_app_icons.dart';

// ignore: must_be_immutable
class EventScreen extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final String description;
  String desc_long;
  String image;
  String url;
  String urlNative;
  String link_text;

  EventScreen({
    super.key,
    required this.title,
    this.description = '',
    this.desc_long = '',
    this.time = '',
    this.date = "",
    this.image = '',
    this.url = '',
    this.urlNative = "",
    this.link_text = "",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          SizedBox(width: 40, height: 40),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
            constraints: const BoxConstraints(minHeight: 200),
            decoration: BoxDecoration(
              color: backgroundVariantColor,
              borderRadius: BorderRadius.circular(13),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(3, 5)),
              ],
              //color: mainColor,
            ),
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              LayoutBuilder(builder: (context, constraints) {
                if (image == "") {
                  return const SizedBox.shrink();
                } else {
                  return ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Image(
                        image: CachedNetworkImageProvider(image),
                      ),
                    ),
                  );
                }
              }),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 36, color: mainColor, height: 1),
                        ),
                      ),
                      Text(
                        desc_long,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            color: Colors.white),
                      ),
                      LayoutBuilder(builder: (context, constraints) {
                        if (date == "") {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10.0, left: 20, right: 20),
                              child: Text(
                                time,
                                style: const TextStyle(
                                    fontSize: 15, color: mainColor),
                              ),
                            ),
                          );
                        } else {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 20, right: 20),
                                  child: Text(
                                    date,
                                    style: const TextStyle(
                                        fontSize: 15, color: mainColor),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10.0, left: 20, right: 20),
                                  child: Text(
                                    time,
                                    style: const TextStyle(
                                        fontSize: 15, color: mainColor),
                                  ),
                                ),
                              ]);
                        }
                      }),
                      LayoutBuilder(builder: (context, constraints) {
                        if (link_text == "") {
                          return const SizedBox.shrink();
                        } else {
                          return Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () => _launchUrl(url, urlNative),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: Colors.black,
                                elevation: 5,
                                foregroundColor: Colors.white,
                                backgroundColor: mainColor,
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: Text(link_text),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),

                // Test purpose for linking
              ),
            ])),
      ),
    );
  }
}

//Test for linking data
void _launchUrl(String webUrl, String nativeUrl) async {
  //var nativeUrl = "instagram://user?username=medieteknikdagen";
  //var webUrl = "https://www.instagram.com/medieteknikdagen/";

  if (await canLaunchUrlString(nativeUrl)) {
    await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
    //print("native");
  } else if (await canLaunchUrlString(webUrl)) {
    await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
    //print("url");
  } else {
    //print("can't open Instagram");
  }
}
