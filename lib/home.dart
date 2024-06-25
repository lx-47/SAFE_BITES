import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'allergen.dart';
import 'cam.dart';
import 'users.dart';

class MyHomePage extends StatelessWidget {
  final selectedUser;
  const MyHomePage({this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(0xFFA2F693),
        elevation: 2,
        automaticallyImplyLeading: false,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserPage()),
                );
              },
              icon: const Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              iconSize: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
                width: 384,
              ),
               Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
                      if (snapshot.hasData) {
                        final selectedUser = snapshot.data!.getString('selectedname');
                        return Text(
                          "Hey ${selectedUser ?? 'User'}!",
                          style: const TextStyle(fontSize: 27),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/image2.png',
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 336,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllergenListPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: const Color(0xFFA2F693),
                  ),
                  child: const Text(
                    'My Allergen List',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 336,
                height: 180,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    backgroundColor: const Color(0xFFA2F693),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/camicon.png',
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Scanner',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
