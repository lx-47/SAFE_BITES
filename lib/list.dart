import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'database.dart';

class ExcludedIngredientsPage extends StatelessWidget {
  const ExcludedIngredientsPage({super.key});

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
      body: const ExtendedList(),
    );
  }
}

class ExtendedList extends StatefulWidget {
  const ExtendedList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExtendedListState createState() => _ExtendedListState();
}

class _ExtendedListState extends State<ExtendedList> {
  late List<dynamic> allergens;
  List<String> selectedAllergens = [];

  @override
  void initState() {
    super.initState();
    fetchselecteduserid();
  }

  Future<void> readJsonData() async {
    String jsonData = await rootBundle.loadString('assets/allergens.json');
    Map<String, dynamic> data = json.decode(jsonData);
    allergens = data['allergens'];
    setState(() {});
  }

  void fetchselecteduserid() async {
    final userid = Db.selectedUserId;
    final allergens = await Db.instance.fetchUserSelectedAllergens(userid!);

    selectedAllergens = allergens.map((item) => item.toLowerCase()).toList();
    readJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Excluded Ingredients',
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
                bottom: BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: selectedAllergens.length,
        itemBuilder: (context, index) {
          final allergenName = selectedAllergens[index];
          final allergen = allergens.firstWhere(
            (allergen) => allergen['name'] == allergenName,
            orElse: () => null,
          );
          if (allergen == null) {
            return Container();
          }

          final alternateAllergens = allergen['alternate'] as List<dynamic>;
          return Column(
            children: [
              ListTile(
                title: Text(allergenName),
                subtitle: Text(alternateAllergens.join(", ")),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
