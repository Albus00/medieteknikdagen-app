// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:mtd_app/models/mtdgruppen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';

import 'package:mtd_app/style/colors.dart';

import 'package:url_launcher/url_launcher_string.dart';

import '../../icons/custom_app_icons.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {
  // Wheater to loop through elements
  final bool _loop = true;

  // Scroll controller for carousel
  late InfiniteScrollController _controller;

  // Maintain current index of carousel
  int _selectedIndex = 0;

  String _selectedIndexName = mtdgruppen_list[0].name;
  String _selectedIndexPost = mtdgruppen_list[0].role;
  String _selectedIndexMail = mtdgruppen_list[0].contac_mail;

  // Width of each item
  final double _itemExtent = 150;

  // Get screen width of viewport.
  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/MTD_bilder/');
  }

  launcMailto(mail) async {
    final mailtoLink = Mailto(
      to: [mail],
    );
    await launchUrl(Uri.parse('$mailtoLink'));
  }

  final String aboutTitle = "Medieteknikdagen";
  final String about =
      "Medieteknikdagen är medieteknikstudenternas årliga arbetsmarknadsdag på Linköpings universitet. Vi förenar företag och studenter och skapar kontakter för livet!";
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
              child: Text("MTD",
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
          actions: const [
            SizedBox(width: 40, height: 40),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundVariantColor,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(10, 10),
                                blurRadius: 10),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          about,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Lato',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Text(
                            "Det är vi som representerar",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "MEDIETEKNIKDAGEN",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: SizedBox(
                          height: 300,
                          child: InfiniteCarousel.builder(
                            center: true,
                            itemCount: mtdgruppen_list.length,
                            itemExtent: _itemExtent,
                            velocityFactor: 0.8,
                            scrollBehavior: kIsWeb
                                ? ScrollConfiguration.of(context).copyWith(
                                    dragDevices: {
                                      // Allows to swipe in web browsers
                                      PointerDeviceKind.touch,
                                      PointerDeviceKind.mouse
                                    },
                                  )
                                : null,
                            loop: _loop,
                            controller: _controller,
                            onIndexChanged: (index) {
                              if (_selectedIndex != index) {
                                setState(() {
                                  // _itemExtent = 240;
                                  _selectedIndex = index;
                                  _selectedIndexName =
                                      mtdgruppen_list[index].name;
                                  _selectedIndexPost =
                                      mtdgruppen_list[index].role;
                                  _selectedIndexMail =
                                      mtdgruppen_list[index].contac_mail;
                                });
                              }
                            },
                            itemBuilder: (context, itemIndex, realIndex) {
                              //final currentComp = mtdgruppen_list[itemIndex];
                              // final midperson = notificationsData[realIndex];
                              final currentOffset = _itemExtent * realIndex;
                              return AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  final diff =
                                      (_controller.offset - currentOffset);
                                  const maxPadding = 10.0;
                                  final carouselRatio2 =
                                      _itemExtent / maxPadding;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: (diff / carouselRatio2).abs(),
                                      bottom: (diff / carouselRatio2).abs(),
                                    ),
                                    child: child,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _controller.animateToItem(realIndex);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: kElevationToShadow[1],
                                        image: DecorationImage(
                                          image: AssetImage(
                                              mtdgruppen_list[itemIndex].image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                    Text(_selectedIndexName,
                        style: const TextStyle(
                            fontSize: 25,
                            color: mainColor,
                            fontWeight: FontWeight.bold)),
                    Text(_selectedIndexPost,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20.0),
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (_selectedIndexMail == "") {
                          return const SizedBox.shrink();
                        } else {
                          return ElevatedButton(
                            onPressed: () => launcMailto(_selectedIndexMail),
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
                            child: Text("Kontakta"),
                          );
                        }
                      }),
                    ),
                  ],
                );
              },
              childCount: 1,
            ),
          )
        ]));
  }
}

// void _launchURL(String selectedMail) async {
//   final Uri params = Uri(
//     scheme: 'mailto',
//     path: selectedMail,
//   );
//   String url = params.toString();
//   if (await canLaunchUrlString(url)) {
//     await launchUrlString(url);
//   } else {
//     //print('Could not launch $url');
//   }
// }
