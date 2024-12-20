import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//NOTIFICATIONS
import 'package:mtd_app/notification.dart';

import 'package:mtd_app/mainpage/gridviewer.dart';
import 'package:mtd_app/mainpage/testframe.dart';
import 'package:mtd_app/mainpage/post_feed.dart';
import 'package:mtd_app/style/colors.dart';

import '../icons/custom_app_icons.dart';

import 'mainpage/category/events.dart';
import 'mainpage/category/contactus.dart';
import 'mainpage/goldhunt.dart';
import 'mainpage/ticket.dart';

import 'package:mtd_app/models/companies_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtd_app/mainpage/companyscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

// List<Route> myRoute = [
//   MaterialPageRoute(builder: (_) => const Companies()),
//   MaterialPageRoute(builder: (_) => const Schedule()),
//   MaterialPageRoute(builder: (_) => const MapMap()),
// ];

Stream<List<Company>> readCompanyWelcome1() => FirebaseFirestore.instance
    .collection("Companies")
    .orderBy("isHuvudsponsor")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Company.fromJson(doc.data())).toList());

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  //DateTime dateFormat = new DateTime("YYYY-MM-dd HH:mm:ss")

  final List<Widget> _widgetOptions = <Widget>[
    const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //AppHeader(),
        TestFrame(),
        //AppWelcomer(),
        // AppSearch(),
        //AppMountListView(),

        //AppCategoryList(),
        //AppBottomBar(),

        //Test Wallah
      ],
    ),
    const Column(children: [
      // Search(),
      GridViewer(),
    ]),
    //***  SAVE COMPANIES, REQUIRES USER ***/
    // Column(children: const [
    //   SavedList(),
    // ]),
    const Column(children: [
      Event(),
      //Settings(),
    ]),
    /* const Column(children:[
      //TestFrame(),
      Quiz(),
    ]), */
    const Column(children: [
      //TestFrame(),
      PostFeed(),
    ]),
    //HÄR KAN DU KALLA PÅ EN NY SIDA.
  ];

  @override
  void initState() {
    //NOTIFICATION
    final firebaseMessaging = FCM();

    firebaseMessaging.setPermission();
    firebaseMessaging.setNotifications();
    firebaseMessaging.fcmSubscribe("123");

    //DateTime currentDate =
    //DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    //print(currentDate.toString().replaceAll("00:00:00.000", ""));

    // firebaseMessaging.addToNotification(
    //     "Violet",
    //     "Ett test event",
    //     "Test_text",
    //     "klicka här",
    //     "https://thumbs.dreamstime.com/b/example-red-tag-example-red-square-price-tag-117502755.jpg",
    //     "https://www.google.com/?&hl=sv",
    //     "https://www.google.com/?&hl=sv");

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: AppBar(
            centerTitle: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
              // Status bar color
              //statusBarColor: Colors.white,
              statusBarColor: Color.fromARGB(255, 19, 41, 61),

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.light, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const InkWell(
                        child: Icon(
                          MyFlutterApp.mtd_svart,
                          color: Colors.white,
                          //color: mainColor,
                          size: 40,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 4, right: 8),
                        child: Icon(
                          Icons.favorite,
                          size: 22,
                        ),
                      ),
                      StreamBuilder<List<Company>>(
                        stream: readCompanyWelcome1(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong!');
                          } else if (snapshot.hasData) {
                            var companies = snapshot.data!;
                            companies.shuffle();
                            var currentComp = companies.first;

                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CompanyScreen(
                                        image: currentComp.image,
                                        name: currentComp.name,
                                        description: currentComp.description,
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
                                child: currentComp.image == ""
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "hej",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )
                                    : Container(
                                        width: 150,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                currentComp.image),
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          } else {
                            return const Text('Loading...');
                          }
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        color: Colors.white,
                        icon: const Icon(
                          Icons.supervised_user_circle,
                          size: 35,
                          //color: mainColor,
                        ),
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            Navigator.of(context).push((MaterialPageRoute(
                                builder: (_) => const ContactUs())));
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            iconTheme: const IconThemeData(color: mainColor),
          ),
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('GoldHunt').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        bottom: 90.0), // Adjust for overlap
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: FloatingActionButton(
                        shape: const CircleBorder(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GoldHuntPage()),
                          );
                        },
                        backgroundColor: gold,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.transparent
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.0, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.6),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/custom_icons/mtd-tree.png",
                            width: 70,
                            height: 70,
                            color: darkerGold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // Return an empty container if no data
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('tickets').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 90.0),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketsPage()),
                          );
                        },
                        backgroundColor: mainColor, // Set your preferred color
                        child: const Icon(
                          Icons
                              .airplane_ticket_rounded, // Replace with your preferred icon
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // Return an empty container if no data
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: backgroundVariantColor,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            height: Platform.isAndroid
                ? MediaQuery.of(context).size.height * 0.09
                : MediaQuery.of(context).size.height * 0.1,
            child: CupertinoTabBar(
              //backgroundColor: mainColor,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.event,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.article,
                  ),
                ),
              ],
              currentIndex: _selectedIndex,
              activeColor: Colors.white,
              inactiveColor: Colors.white70,
              backgroundColor: backgroundVariantColor,
              onTap: _onItemTapped,
            ),
          ),
        ));
  }
}
