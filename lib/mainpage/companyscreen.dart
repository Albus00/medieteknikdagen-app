import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mtd_app/style/colors.dart';

// ignore: must_be_immutable
class CompanyScreen extends StatelessWidget {
  final String image;

  final String name;
  final String description;
  // final String location;
  final bool hasExjobb;
  final bool hasSommarjobb;
  final bool hasJobb;
  final bool hasPraktik;
  final bool hasTrainee;

  const CompanyScreen({
    super.key,
    required this.name,
    required this.description,
    //  required this.location,
    required this.hasExjobb,
    required this.hasSommarjobb,
    required this.hasJobb,
    required this.hasPraktik,
    required this.hasTrainee,
    required this.image,
  });

  // Future addToFavorites() async {
  //   CollectionReference _collectionRef =
  //       FirebaseFirestore.instance.collection("Favorites");

  //   return _collectionRef.doc().collection("Companies").doc().set({
  //     "name": name,
  //     "description": description,
  //     "hasExjobb": hasExjobb,
  //     "hasSommarjobb": hasSommarjobb,
  //     "hasJobb": hasJobb,
  //     "image": image,
  //     "isSaved": isSaved,
  //   });
  // }

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
        actions: const [
          SizedBox(width: 40, height: 40),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundVariantColor2,
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
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 40,
                    color: mainColor,
                    height: 1,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                    bottom: 10.0, top: 10.0, left: 17.0, right: 10),
                child: Wrap(
                  children: [
                    if (hasExjobb == true) ...[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 3.0, right: 4.0),
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Exjobb',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                    if (hasSommarjobb == true) ...[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 3.0, right: 4.0),
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Sommarjobb',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                    if (hasJobb == true) ...[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 3.0, right: 4.0),
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Jobb',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                    if (hasPraktik == true) ...[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 3.0, right: 4.0),
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Praktik',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                    if (hasTrainee == true) ...[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 3.0, right: 4.0),
                        padding: const EdgeInsets.only(
                            top: 3.0, bottom: 3.0, left: 5.0, right: 5.0),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('Trainee',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    if (description == "") {
                      return const SizedBox.shrink();
                    } else {
                      return Container(
                        //color: Colors.blue,
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          description,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: Colors.white),
                        ),
                      );
                    }
                  }),
                  LayoutBuilder(builder: (context, constraints) {
                    if (image == "") {
                      return const SizedBox.shrink();
                    } else {
                      return Container(
                        //color: Colors.green,
                        margin: const EdgeInsets.all(20.0),
                        alignment: Alignment.topCenter,
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: Image(
                            image: CachedNetworkImageProvider(image),
                          ),
                        ),
                      );
                    }
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
