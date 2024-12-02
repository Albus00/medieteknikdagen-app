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

  void nextImage() {
    if (documents.isNotEmpty) {
      setState(() {
        currentIndex = (currentIndex + 1) % documents.length;
      });
    }
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Bild ${documents.length - currentIndex} av ${documents.length}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
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
                      : CircularProgressIndicator(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  onPressed: previousImage,
                  child: Text('BLÄDDRA'),
                ),
              ],
            ),
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
