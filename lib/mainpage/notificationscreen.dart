import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mtd_app/style/colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationScreen extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String link;
  final String linktitle;
  final String url;
  final String urlNative;

  const NotificationScreen({
    super.key,
    this.image = "",
    required this.title,
    required this.description,
    this.link = "",
    this.linktitle = '',
    this.url = '',
    this.urlNative = '',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        title: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                top: 200, left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: backgroundVariantColor.withOpacity(0.9),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(3, 5),
                ),
              ],
            ),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Lato',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: LayoutBuilder(builder: (context, constraints) {
                    if (linktitle == "") {
                      return const SizedBox.shrink();
                    } else {
                      return ElevatedButton(
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
                        child: Text(linktitle),
                      );

                      // Container(
                      //   padding: const EdgeInsets.all(20.0),
                      //   child: InkWell(
                      //     child: Text(
                      //       linktitle,
                      //       style: const TextStyle(
                      //         fontSize: 20,
                      //         color: Colors.blue,
                      //         fontFamily: 'Lato',
                      //       ),
                      //     ),
                      //     onTap: () => _launchUrl(url, urlNative),
                      //   ),
                      // );
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _launchUrl(String webUrl, String nativeUrl) async {
  if (await canLaunchUrlString(nativeUrl)) {
    await launchUrlString(nativeUrl, mode: LaunchMode.externalApplication);
  } else if (await canLaunchUrlString(webUrl)) {
    await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
  }
}
