import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtd_app/style/colors.dart';

class GoldHuntPage extends StatefulWidget {
  const GoldHuntPage({super.key});

  @override
  _GoldHuntPageState createState() => _GoldHuntPageState();
}

class _GoldHuntPageState extends State<GoldHuntPage> {
  int currentIndex = 0;
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void fetchImages() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('GoldHunt')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      documents = snapshot.docs;
    });
  }

  void previousImage() {
    if (documents.isNotEmpty) {
      setState(() {
        currentIndex = (currentIndex - 1 + documents.length) % documents.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var imageUrl = documents.isNotEmpty
        ? documents[currentIndex].get('imgUrl') ?? 'default_image_url'
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGold,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: darkGold,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'GULDJAKTEN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Flexible(
                    child: imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit
                                    .contain, // Ensures the image scales down to fit
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: AspectRatio(
                                  aspectRatio: 5 / 7,
                                  child: SizedBox(
                                    width: double.infinity,
                                  ),
                                )),
                          )),
              ),
              SizedBox(height: 10),
              Text(
                'Bild ${documents.length - currentIndex} av ${documents.length}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                onPressed: previousImage,
                child: Text('BLÄDDRA', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GoldHuntPage(),
  ));
}
