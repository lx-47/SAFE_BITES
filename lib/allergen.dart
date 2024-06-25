import 'package:flutter/material.dart';
import 'list.dart';
import 'database.dart';

class AllergenListPage extends StatefulWidget {
  const AllergenListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllergenListPageState createState() => _AllergenListPageState();
}

class _AllergenListPageState extends State<AllergenListPage> {
  @override
  void initState() {
    super.initState();
    loadUserAllergens();
  }

  void loadUserAllergens() async {
    final dbHelper = Db.instance;
    final users = await dbHelper.getUsers();
    if (users.isNotEmpty) {
      final userId = Db.selectedUserId;
      final userAllergens = await dbHelper.fetchUserSelectedAllergens(userId!);

      // Set the initial allergen states based on the user's allergens
      for (var i = 0; i < allergens.length; i++) {
        final allergen = allergens[i];
        allergenStates[i] = userAllergens.contains(allergen);
      }

      setState(() {});
    }
  }

  final List<String> allergens = [
    'Celery',
    'Crustaceans Shellfish',
    'Eggs',
    'Fish',
    'Wheat',
    'Lupins',
    'Milk',
    'Mustard',
    'Molluscs',
    'Tree Nuts',
    'Peanuts',
    'Sesame Seeds',
    'Sulphites',
    'Soyabeans',
  ];

  List<bool> allergenStates = List.filled(14, false);

  void toggleAllergenState(int index) async {
    setState(() {
      allergenStates[index] = !allergenStates[index];
    });

    final selectedAllergens = <String>[];
    for (var i = 0; i < allergenStates.length; i++) {
      if (allergenStates[i]) {
        selectedAllergens.add(allergens[i]);
      }
    }
    final selectedUserId = Db.selectedUserId;
    final name = Db.selectedname;
    await Db.instance.updateUserAllergens(selectedUserId!, selectedAllergens);
    print('Updated allergens for user : $name');
    print('$selectedAllergens');
  }

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
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Image.asset(
                'assets/images/backarrow.png',
                height: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Center(
              child: Text(
                'My Allergen List',
                style: TextStyle(color: Colors.black),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExcludedIngredientsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              )
            ],
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text(allergens[index]),
                  trailing: Switch(
                    value: allergenStates[index],
                    onChanged: (value) {
                      toggleAllergenState(index);
                    },
                  ),
                );
              },
              childCount: allergens.length,
            ),
          ),
        ],
      ),
    );
  }
}
