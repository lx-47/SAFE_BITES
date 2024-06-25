import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedBackPage extends StatelessWidget {
  const FeedBackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(0xFFA2F693),
        elevation: 2,
        automaticallyImplyLeading:
            false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 40,
            ),
            const SizedBox(width: 6),
            const Text(
              'Safe Bites',
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Feedback(),
    );
  }
}

class Feedback extends StatelessWidget {
  Feedback({super.key});

  final Uri _url = Uri.parse(
      'https://docs.google.com/forms/d/e/1FAIpQLSdcnERZGdp4-QUnJy7OcCCrSm90vUGsoi9CDFP8BmIa4VXp5g/viewform');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true, 
        leading: IconButton(
          icon: Image.asset('assets/images/backarrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1.0))),
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 25, right: 15, left: 15),
            child: Text(
              'Safe Bites helps the process of purchasing food items from shops without worrying about the allergens you may be suffering from. We can easily scan the ingredients list and identify the potential allergens present in them which you are allergic to.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'The app includes all the major allergen groups present. If you would like any other groups, please mention it in the feedback.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            onPressed: () async {
              if (await launchUrl(_url)) {
              } else {
                throw Exception('Could not launch $_url');
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              textStyle: const TextStyle(fontSize: 20),
              minimumSize: const Size(
                  double.infinity, 50), 
            ),
            icon: const Icon(Icons.feedback),
            label: const Text('Feedback'),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: () async {
              String email = Uri.encodeComponent("safebites@gmail.com");
              Uri mail = Uri.parse("mailto:$email");
              if (await launchUrl(mail)) {
              } else {
                throw 'Could not launch $email';
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              textStyle: const TextStyle(fontSize: 20),
              minimumSize: const Size(
                  double.infinity, 50),
            ),
            icon: const Icon(Icons.mail),
            label: const Text('Contact Us'),
          ),
        ],
      ),
    );
  }
}
