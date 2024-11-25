import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:mtd_app/mainpage/category/map.dart';
import 'package:mtd_app/mainpage/companyscreen.dart';
import 'package:mtd_app/models/companies_firebase.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mtd_app/style/colors.dart';

Stream<List<Company>> readCompany() => FirebaseFirestore.instance
    .collection("Companies")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Company.fromJson(doc.data())).toList());

Stream<List<Company>> readCompanySearch(String query) =>
    FirebaseFirestore.instance
        .collection("Companies")
        .where('name', isGreaterThanOrEqualTo: query)
        // ignore: prefer_interpolation_to_compose_strings
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Company.fromJson(doc.data())).toList());

Future<List> readCompanySearchFut() async {
  var notifs = await FirebaseFirestore.instance.collection("Companies").get();

  return List<Company>.from(
      notifs.docs.map((doc) => Company.fromJson(doc.data())).toList());
}

class GridViewer extends StatefulWidget {
  const GridViewer({super.key});

  @override
  State<GridViewer> createState() => _GridViewerState();
}

class _GridViewerState extends State<GridViewer> {
  // ignore: prefer_final_fields
  TextEditingController _searchController = TextEditingController();

  CollectionReference allNoteCollection =
      FirebaseFirestore.instance.collection('Companies');
  List<DocumentSnapshot> documents = [];

  String searchText = '';

  Color _containerColor1 = Colors.white;
  Color _textColor1 = mainColor;

  Color _containerColor2 = Colors.white;
  Color _textColor2 = mainColor;

  Color _containerColor3 = Colors.white;
  Color _textColor3 = mainColor;

  Color _containerColor4 = Colors.white;
  Color _textColor4 = mainColor;

  Color _containerColor5 = Colors.white;
  Color _textColor5 = mainColor;

  bool showFilters = false;

  bool exjobbSearch = false;
  bool sommarjobbSearch = false;
  bool jobbSearch = false;
  bool praktikSearch = false;
  bool traineeSearch = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Upptäck',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(children: [
                            TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                              decoration: InputDecoration(
                                //labelText: "Search",
                                border: InputBorder.none,
                                hintText: "Search",
                                hoverColor: Colors.grey[200],
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.black),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 2.0, right: 5.0),
                          padding: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                            color: _containerColor1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Exjobb',
                              style: TextStyle(color: _textColor1)),
                        ),
                        onTap: () {
                          setState(() {
                            exjobbSearch == false
                                ? exjobbSearch = true
                                : exjobbSearch = false;

                            _containerColor1 = _containerColor1 == Colors.white
                                ? mainColor
                                : Colors.white;

                            _textColor1 = _textColor1 == mainColor
                                ? Colors.white
                                : mainColor;
                          });
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 3.0, right: 5.0),
                          padding: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                            color: _containerColor2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Sommarjobb',
                              style: TextStyle(color: _textColor2)),
                        ),
                        onTap: () {
                          setState(() {
                            sommarjobbSearch == false
                                ? sommarjobbSearch = true
                                : sommarjobbSearch = false;
                            _containerColor2 = _containerColor2 == Colors.white
                                ? mainColor
                                : Colors.white;

                            _textColor2 = _textColor2 == mainColor
                                ? Colors.white
                                : mainColor;
                          });
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 3.0, right: 5.0),
                          padding: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                            color: _containerColor3,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Jobb',
                              style: TextStyle(color: _textColor3)),
                        ),
                        onTap: () {
                          setState(() {
                            jobbSearch == false
                                ? jobbSearch = true
                                : jobbSearch = false;
                            _containerColor3 = _containerColor3 == Colors.white
                                ? mainColor
                                : Colors.white;

                            _textColor3 = _textColor3 == mainColor
                                ? Colors.white
                                : mainColor;
                          });
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 3.0, right: 5.0),
                          padding: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                            color: _containerColor4,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Praktik',
                              style: TextStyle(color: _textColor4)),
                        ),
                        onTap: () {
                          setState(() {
                            praktikSearch == false
                                ? praktikSearch = true
                                : praktikSearch = false;
                            _containerColor4 = _containerColor4 == Colors.white
                                ? mainColor
                                : Colors.white;

                            _textColor4 = _textColor4 == mainColor
                                ? Colors.white
                                : mainColor;
                          });
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 3.0, right: 5.0),
                          padding: const EdgeInsets.only(
                              top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                          decoration: BoxDecoration(
                            color: _containerColor5,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Trainee',
                              style: TextStyle(color: _textColor5)),
                        ),
                        onTap: () {
                          setState(() {
                            traineeSearch == false
                                ? traineeSearch = true
                                : traineeSearch = false;
                            _containerColor5 = _containerColor5 == Colors.white
                                ? mainColor
                                : Colors.white;

                            _textColor5 = _textColor5 == mainColor
                                ? Colors.white
                                : mainColor;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List>(
              // initialData: readCompany(),
              future: readCompanySearchFut(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Something went wrong!  '); //${snapshot.error}
                } else if (snapshot.hasData) {
                  var companyss = snapshot.data!;

                  if (exjobbSearch == true) {
                    companyss = companyss.where((element) {
                      return element.hasExjobb.toString().contains("true");
                    }).toList();
                  }

                  if (sommarjobbSearch == true) {
                    companyss = companyss.where((element) {
                      return element.hasSommarjobb.toString().contains("true");
                    }).toList();
                  }

                  if (jobbSearch == true) {
                    companyss = companyss.where((element) {
                      return element.hasJobb.toString().contains("true");
                    }).toList();
                  }

                  if (praktikSearch == true) {
                    companyss = companyss.where((element) {
                      return element.hasPraktik.toString().contains("true");
                    }).toList();
                  }

                  if (traineeSearch == true) {
                    companyss = companyss.where((element) {
                      return element.hasTrainee.toString().contains("true");
                    }).toList();
                  }

                  if (searchText.isNotEmpty) {
                    companyss = companyss.where((element) {
                      return element.name
                          .toString()
                          .toLowerCase()
                          .contains(searchText.toLowerCase());
                    }).toList();
                  }

                  companyss.shuffle();

                  return ScrollShadow(
                    size: 1,
                    color: mainColor.withOpacity(0.2),
                    child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20.0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: companyss.length, //snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final currentComp = companyss[index];

                          return GestureDetector(onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyScreen(
                                  image: currentComp.image,
                                  name: currentComp.name,
                                  description: currentComp.description,
                                  hasExjobb: currentComp.hasExjobb,
                                  hasSommarjobb: currentComp.hasSommarjobb,
                                  hasPraktik: currentComp.hasPraktik,
                                  hasTrainee: currentComp.hasTrainee,
                                  hasJobb: currentComp.hasJobb,
                                ),
                              ),
                            );
                          }, child:
                              LayoutBuilder(builder: (context, constraints) {
                            if (currentComp.image == "") {
                              return Container(
                                  alignment: Alignment.center,
                                  child: Text(currentComp.name,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white)));
                            } else {
                              return Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            currentComp.image),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }));
                        }),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ]),
    );
  }
}
