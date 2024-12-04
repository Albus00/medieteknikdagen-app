import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mtd_app/style/colors.dart';
import 'dart:math';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<DocumentSnapshot> documents = [];
  double tiltX = 0; // Rotation around X-axis
  double tiltY = 0; // Rotation around Y-axis
  final double maxTilt = pi / 10; // Maximum tilt (in radians)
  final double tiltIntensity = 0.8; // Adjust sensitivity of tilt
  Random random = Random(); // For selecting a random ticket

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  void fetchImages() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .get(); // Fetch all tickets

    setState(() {
      documents = snapshot.docs;
    });
  }

  DocumentSnapshot? getRandomTicket() {
    if (documents.isEmpty) return null;
    return documents[random.nextInt(documents.length)];
  }

  @override
  Widget build(BuildContext context) {
    var randomTicket = getRandomTicket();
    var imageUrl = randomTicket?.get('imgUrl') ?? 'default_image_url';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: party1,
        iconTheme: const IconThemeData(color: Colors.white),
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
                    shadows: const [
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
                    fontSize: 60,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                    shadows: const [
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
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // Obtain the size of the card
                      final renderBox = context.findRenderObject() as RenderBox;
                      final size = renderBox.size;

                      // Normalize touch position to range [-0.5, 0.5]
                      final dx =
                          (details.localPosition.dx / size.width - 0.5) * 2;
                      final dy =
                          (details.localPosition.dy / size.height - 0.5) * 2;

                      setState(() {
                        // Map normalized values to tilt angles
                        tiltX = (dy * tiltIntensity).clamp(-1, 1) * maxTilt;
                        tiltY = (-dx * tiltIntensity).clamp(-1, 1) * maxTilt;
                      });
                    },
                    onPanEnd: (_) {
                      // Reset tilt when touch ends
                      setState(() {
                        tiltX = 0;
                        tiltY = 0;
                      });
                    },
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001) // Perspective
                        ..rotateX(tiltX)
                        ..rotateY(tiltY),
                      alignment: FractionalOffset.center,
                      child: imageUrl.isNotEmpty
                          ? AspectRatio(
                              aspectRatio: 5 / 7,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    const BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 5.0,
                                      color: Colors.deepOrangeAccent,
                                    ),
                                    const BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 10.0,
                                      color: Colors.orangeAccent,
                                    ),
                                    BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 20.0,
                                      color: mainColor,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        imageUrl,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(height: 300),
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
