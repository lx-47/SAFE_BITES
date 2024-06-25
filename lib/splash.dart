import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedName = prefs.getString('selectedname');
    int? selectedid = prefs.getInt('selectedid');

    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(selectedUser: selectedName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA2F693),
      body: Center(
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 80,
              ),
            ),
            Image.asset('assets/images/logo.png'),
            const Text(
              'Safe Bites',
              style: TextStyle(
                fontFamily: 'DancingScript',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0, top: 100),
              child: Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/images/image1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
