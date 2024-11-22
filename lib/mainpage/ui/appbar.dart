// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// //NOTIFICATIONS
// import 'package:mtd_app/notification.dart';

// import 'package:mtd_app/mainpage/gridviewer.dart';
// import 'package:mtd_app/mainpage/testframe.dart';
// import 'package:mtd_app/mainpage/post_feed.dart';
// import 'package:mtd_app/style/colors.dart';

// import 'package:mtd_app/icons/custom_app_icons.dart';

// import 'package:mtd_app/mainpage/category/events.dart';
// import 'package:mtd_app/mainpage/category/contactus.dart';

// import 'package:mtd_app/models/companies_firebase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mtd_app/mainpage/companyscreen.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// Stream<List<Company>> readCompanyWelcome1() => FirebaseFirestore.instance
//     .collection("Companies")
//     .orderBy("isHuvudsponsor")
//     .snapshots()
//     .map((snapshot) =>
//         snapshot.docs.map((doc) => Company.fromJson(doc.data())).toList());

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//             centerTitle: true,
//             systemOverlayStyle: const SystemUiOverlayStyle(
//               // Status bar color
//               //statusBarColor: Colors.white,
//               statusBarColor: Color.fromARGB(255, 19, 41, 61),

//               // Status bar brightness (optional)
//               statusBarIconBrightness:
//                   Brightness.light, // For Android (dark icons)
//               statusBarBrightness: Brightness.light, // For iOS (dark icons)
//             ),
//             elevation: 0,
//             backgroundColor: Colors.transparent,
//             title: Container(
//               margin: const EdgeInsets.only(top: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                           MyFlutterApp.mtd_svart,
//                   Row(
//                     children: [
//                       const InkWell(
//                         child: Icon(
//                           MyFlutterApp.mtd_svart,
//                           color: Colors.white,
//                           //color: mainColor,
//                           size: 40,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(left: 4, right: 8),
//                       StreamBuilder<List<Company>>(
//                         stream: readCompanyWelcome1(),
//                           size: 22,
//                         ),
//                       ),
//                       StreamBuilder<List<Company>>(
//                         stream: readCompanyWelcome1(),
//                         builder: (context, snapshot) {
//                           if (snapshot.hasError) {
//                             return Text('Something went wrong!');
//                           } else if (snapshot.hasData) {
//                             var companies = snapshot.data!;
//                             companies.shuffle();
//                             var currentComp = companies.first;

//                             return Center(
//                                       builder: (context) => CompanyScreen(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CompanyScreen(
//                                         image: currentComp.image,
//                                         name: currentComp.name,
//                                         description: currentComp.description,
//                                         hasExjobb: currentComp.hasExjobb,
//                                         hasSommarjobb:
//                                             currentComp.hasSommarjobb,
//                                         hasPraktik: currentComp.hasPraktik,
//                                         hasTrainee: currentComp.hasTrainee,
//                                         hasJobb: currentComp.hasJobb,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: currentComp.image == ""
//                                     ? Container(
//                                               );
//                                         }
                                      
//                                         @override
//                                         Size get preferredSize => Size.fromHeight(MediaQuery.of(context).size.height * 0.08);
//                                       }
//                                             image: CachedNetworkImageProvider(
//                                           "hej",
//                                           style: TextStyle(fontSize: 12),
//                                         ),
//                                       )
//                                     : Container(
//                                         width: 150,
//                                         height: 75,
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             image: CachedNetworkImageProvider(
//                                                 currentComp.image),
//                                           ),
//                                         ),
//                                       ),
//                               ),
//                             );
//                           } else {
//                             return const Text('Loading...');
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                             Navigator.of(context).push((MaterialPageRoute(
//                                 builder: (_) => const ContactUs())));
//                         color: Colors.white,
//                         icon: const Icon(
//                           Icons.supervised_user_circle,
//                           size: 35,
//                           //color: mainColor,
//                         ),
//                         onPressed: () {
//                           Future.delayed(Duration.zero, () {
//             iconTheme: const IconThemeData(color: Colors.white),
//                                 builder: (_) => const ContactUs())));
//                           });
//                         },
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             iconTheme: const IconThemeData(color: mainColor),
//           ),
//         )