import 'dart:io';
import 'package:flutter/material.dart';
import 'database.dart';

// ignore: must_be_immutable
class ResultPage extends StatelessWidget {
  final String imagePath;
  late List<String> matchingtitles = [];
  late List<String> matchingwords = [];

  ResultPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    matchingtitles = Db.instance.matchingTitles;
    matchingwords = Db.instance.matchingwords;
    print(matchingtitles);
    String titles = matchingtitles.toSet().toList().join(', ');
    String text = matchingwords.toSet().toList().join(', ');
    print(titles);

    return Scaffold(
      // ignore: sized_box_for_whitespace
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Image.file(File(imagePath)),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
              ),
            ),
            Positioned.fill(
              top: 420,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(30, 30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10),
                                  child: Image.asset(
                                    'assets/images/caution.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "May contain $titles",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Text(
                              'Allergens: $text',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            '${Db.selectedname} is allergic to this product.',
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(30, 30),
                        topRight: Radius.elliptical(30, 30),
                      ),
                    ),
                    child: const Center(
                        child: Text(
                      "UNSAFE",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
