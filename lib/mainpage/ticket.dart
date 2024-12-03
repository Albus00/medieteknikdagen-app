import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtd_app/style/colors.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  int currentIndex = 0;
  List<DocumentSnapshot> documents = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void fetchImages() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .orderBy(FieldPath.documentId)
        .limit(1)
        .get();

    setState(() {
      documents = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    var imageUrl = documents.isNotEmpty
        ? documents[currentIndex].get('imgUrl') ?? 'default_image_url'
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: party1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [party1, party2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'PRE-MTD:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: party1,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        color: Colors.white,
                      ),
                      Shadow(
                        offset: Offset(-1, -1),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Text(
                  'FESTEN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // Use a custom font if needed
                    fontSize: 60,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 10.0,
                        color: Colors.deepOrangeAccent,
                      ),
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 20.0,
                        color: Colors.orangeAccent,
                      ),
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 40.0,
                        color: mainColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: AspectRatio(
                    aspectRatio: 5 / 7, // Adjust the aspect ratio as needed
                    child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10.0,
                            color: Colors.deepOrangeAccent,
                          ),
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 20.0,
                            color: Colors.orangeAccent,
                          ),
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 40.0,
                            color: mainColor,
                          ),
                        ],
                      ),
                      child: imageUrl != null
                          ? ClipRRect(
                              // borderRadius: BorderRadius.circular(40.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight:
                                      300, // Set a reasonable minimum height
                                  maxHeight:
                                      500, // Optional max height for consistency
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit
                                          .cover, // Ensures the image covers the container
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(height: 300),
                    ),
                  ),
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
    home: TicketsPage(),
  ));
}
