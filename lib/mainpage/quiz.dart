import 'package:flutter/material.dart';
import 'package:mtd_app/style/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SvarRebus {
  final String code;
  String image;
  final String order;
  bool codeDone;

  SvarRebus({
    required this.code,
    this.image = "",
    this.order = "",
    this.codeDone = false,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'image': image,
        'order': order,
        'codeDone': codeDone,
      };

  static SvarRebus fromJson(Map<String, dynamic> json) => SvarRebus(
        code: json['code'],
        image: json['image'],
        order: json['order'],
        codeDone: json['codeDone'],
      );
}

Stream<List<SvarRebus>> readSvar() => FirebaseFirestore.instance
    .collection("Rebus")
    .orderBy("order")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => SvarRebus.fromJson(doc.data())).toList());

Future<List> readSvarFut() async {
  var notifs = await FirebaseFirestore.instance
      .collection("Rebus")
      .orderBy("order")
      .get();

  return List<SvarRebus>.from(
      notifs.docs.map((doc) => SvarRebus.fromJson(doc.data())).toList());
}

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late List<bool> codeDone = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  final int listLength = 9;

  @override
  void initState() {
    super.initState();
    loadBoolList();
  }

  Future<void> loadBoolList() async {
    final prefs = await SharedPreferences.getInstance();
    codeDone = List.generate(listLength, (index) {
      return prefs.getBool('bool_$index') ?? false;
    });
    setState(() {});
  }

  Future<void> saveBoolList() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < listLength; i++) {
      await prefs.setBool('bool_$i', codeDone[i]);
    }
  }

  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  final TextEditingController _searchController3 = TextEditingController();
  final TextEditingController _searchController4 = TextEditingController();
  String searchText1 = '';
  String searchText2 = '';
  String searchText3 = '';
  String searchText4 = '';
  String combinedText = '';
  FocusNode field1 = FocusNode();
  FocusNode field2 = FocusNode();
  FocusNode field3 = FocusNode();
  FocusNode field4 = FocusNode();
  bool isEmpty1 = true;
  bool isEmpty2 = true;
  bool isEmpty3 = true;
  bool isEmpty4 = true;

//  Future<void> updateFirestoreDocument() async {
//
//  try {
//    await FirebaseFirestore.instance
//    .collection('Rebus')
//    .doc('Fon4swYolHbanmyJ9vtG')
//    .update({
//      'codeDone': true,
//    });
//
//    print('Document updated successfully');
//  } catch (e) {
//    print('Error updating document: $e');
//  }
//  setState(() {});
//}

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(children: [
      const SizedBox(
        width: 500,
        child: Padding(
          padding: EdgeInsets.only(left: 34.0, bottom: 15),
          child: Text(
            'Rebus',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 0), //(left: 34.5),
              child: Container(
                width: 55,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 70, 83),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(children: [
                  TextField(
                      focusNode: field1,
                      controller: _searchController1,
                      onChanged: (value) {
                        //-----
                        if (value.isNotEmpty && int.tryParse(value) != null) {
                          FocusScope.of(context).requestFocus(field2);
                        } else if (value.isNotEmpty) {
                          //print('inne i else if');
                          FocusScope.of(context).requestFocus(field2);
                        } else {
                          isEmpty1 = value.isEmpty;
                          setState(() {
                            searchText1 = value;
                          });
                        }
                        //-----
                      },
                      onEditingComplete: () {
                        // Check if the entered text is not empty and is a number
                        if (_searchController1.text.isNotEmpty &&
                            int.tryParse(_searchController1.text) != null) {
                          FocusScope.of(context).requestFocus(field2);
                          setState(() {
                            searchText1 = _searchController1.text;
                          });
                        } else {
                          // If the entered text is empty or not a number, move to the previous input box (field1)
                          FocusScope.of(context).requestFocus(field4);
                          setState(() {
                            searchText1 = _searchController1.text;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          //labelText: "Search",
                          border: InputBorder.none,
                          hoverColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.only(left: 15.0)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      )),
                ]),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 0), //(left: 34.5),
              child: Container(
                width: 55,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 70, 83),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(children: [
                  TextField(
                    focusNode: field2,
                    controller: _searchController2,
                    onChanged: (value) {
                      //print(value.isNotEmpty);
                      //print(value.isEmpty);
                      //-----
                      if (value.isNotEmpty && int.tryParse(value) != null) {
                        FocusScope.of(context).requestFocus(field3);
                      } else if (value.isNotEmpty) {
                        //print('inne i else if');
                        FocusScope.of(context).requestFocus(field3);
                      } else {
                        FocusScope.of(context).requestFocus(field1);
                        isEmpty2 = value.isEmpty;
                        setState(() {
                          searchText2 = value;
                        });
                      }
                      //-----
                    },
                    onEditingComplete: () {
                      // Check if the entered text is not empty and is a number
                      if (_searchController2.text.isNotEmpty &&
                          int.tryParse(_searchController2.text) != null) {
                        FocusScope.of(context).requestFocus(field3);
                        setState(() {
                          searchText2 = _searchController2.text;
                        });
                      } else {
                        // If the entered text is empty or not a number, move to the previous input box (field1)
                        FocusScope.of(context).requestFocus(field1);
                        setState(() {
                          searchText2 = _searchController2.text;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        //labelText: "Search",
                        border: InputBorder.none,
                        hoverColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.only(left: 15.0)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 0), //(left: 34.5),
              child: Container(
                width: 55,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 70, 83),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(children: [
                  TextField(
                      focusNode: field3,
                      controller: _searchController3,
                      onChanged: (value) {
                        //-----
                        if (value.isNotEmpty && int.tryParse(value) != null) {
                          FocusScope.of(context).requestFocus(field4);
                          //print('inne4');
                        } else if (value.isNotEmpty) {
                          //print('inne i else if');
                          FocusScope.of(context).requestFocus(field4);
                        } else {
                          //print('hej');
                          FocusScope.of(context).requestFocus(field2);
                          isEmpty3 = value.isEmpty;
                          setState(() {
                            searchText3 = value;
                          });
                        }
                        //-----
                      },
                      onEditingComplete: () {
                        //print('inne3');
                        // Check if the entered text is not empty and is a number
                        if (_searchController3.text.isNotEmpty &&
                            int.tryParse(_searchController3.text) != null) {
                          FocusScope.of(context).requestFocus(field4);
                          //print('inne2');
                          setState(() {
                            searchText3 = _searchController3.text;
                          });
                        } else {
                          // If the entered text is empty or not a number, move to the previous input box (field1)
                          //print('inne');
                          FocusScope.of(context).requestFocus(field2);
                          setState(() {
                            searchText3 = _searchController3.text;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          //labelText: "Search",
                          border: InputBorder.none,
                          hoverColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.only(left: 15.0)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      )),
                ]),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 0), //(left: 34.5),
              child: Container(
                width: 55,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 56, 70, 83),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(children: [
                  TextField(
                      focusNode: field4,
                      controller: _searchController4,
                      onChanged: (value) {
                        //-----
                        if (value.isNotEmpty && int.tryParse(value) != null) {
                          FocusScope.of(context).requestFocus(field1);
                        } else if (value.isNotEmpty) {
                          //print('inne i else if');
                          FocusScope.of(context).requestFocus(field1);
                        } else {
                          FocusScope.of(context).requestFocus(field3);
                          isEmpty4 = value.isEmpty;
                          setState(() {
                            searchText4 = value;
                          });
                        }
                        //-----
                      },
                      onEditingComplete: () {
                        // Check if the entered text is not empty and is a number
                        if (_searchController4.text.isNotEmpty &&
                            int.tryParse(_searchController4.text) != null) {
                          FocusScope.of(context).requestFocus(field1);
                          setState(() {
                            searchText4 = _searchController4.text;
                          });
                        } else {
                          // If the entered text is empty or not a number, move to the previous input box (field1)
                          FocusScope.of(context).requestFocus(field3);
                          setState(() {
                            searchText4 = _searchController4.text;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          //labelText: "Search",
                          border: InputBorder.none,
                          hoverColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.only(left: 15.0)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      )),
                ]),
              ),
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: TextButton(
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all<Size>(
              const Size(326.0, 50.0),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15.0))), // Adjust the radius as needed
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            backgroundColor: WidgetStateProperty.all<Color>(mainColor),
          ),
          onPressed: () {
            if (!isEmpty1 && !isEmpty2 && !isEmpty3 && !isEmpty4) {
              setState(() {
                combinedText =
                    searchText1 + searchText2 + searchText3 + searchText4;
                //codeDone[0] = true;
              });

              _searchController1.clear();
              _searchController2.clear();
              _searchController3.clear();
              _searchController4.clear();
            } else {}
          },
          child: const Text('Lös in'),
        ),
      ),
      Expanded(
          child: FutureBuilder<List>(
              future: readSvarFut(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text(
                      'Something went wrong!   '); //${snapshot.error}
                } else if (snapshot.hasData) {
                  var order = snapshot.data!;
                  var eventsData = snapshot.data!;

                  order = order
                      .map((element) {
                        return element;
                      })
                      .toSet()
                      .toList();

                  return ScrollShadow(
                      color: backgroundColor,
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20.0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: eventsData.length,
                        itemBuilder: (context, index) {
                          final currentSvar = eventsData[index];
//
                          return GestureDetector(child: LayoutBuilder(
                                  builder: (context, constraints) {
                            if (currentSvar.image == "") {
                              return Container(
                                  alignment: Alignment.center,
                                  //  color: Colors.grey.withOpacity(0.2),
                                  child: Text(currentSvar.order,
                                      style: const TextStyle(fontSize: 12)));
                            } else if (currentSvar.code == combinedText) {
                              codeDone[int.parse(currentSvar.order)] = true;
                              saveBoolList();

                              //print(codeDone);
                              return Container(
                                  decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      currentSvar.image),
                                  fit: BoxFit.cover,
                                ),
                              ));
                            } else if (codeDone[int.parse(currentSvar.order)] ==
                                true) {
                              return Container(
                                  decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      currentSvar.image),
                                  fit: BoxFit.cover,
                                ),
                              ));
                            } else if (currentSvar.order != "") {
                              int temp = int.parse(currentSvar.order) + 1;
                              return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  temp.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 40),
                                ),
                              );
                            } else {
                              return const Text('hej',
                                  style: TextStyle(color: Colors.white));
                            }
                          })
//
                              );
                        },
                      ));
                } else {
                  return const Text('Loading...');
                }
              }))
    ]));
  }
}
