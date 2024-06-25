import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Db {
  static final Db instance = Db._();
  static Database? _database;
  static int? selectedUserId;
  static String? selectedname;
  List<String>? text;
  List<String> matchingTitles = [];
  List<String> matchingwords = [];

  Db._();

  Future<void> _initSelectedName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedname = prefs.getString('selectedname');
    selectedUserId = prefs.getInt('selectedid');
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'my_database.db');

    await _initSelectedName();

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        allergens TEXT
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<bool> allergenresult() async {
    final db = await instance.database;
    final allergens = await db.query(
      'users',
      columns: ['allergens'],
      where: 'id = ?',
      whereArgs: [selectedUserId],
    );
    List<String> allergenList = [];
    String alist = "";
    bool safe = true;
    for (final allergenMap in allergens) {
      final allergen = allergenMap['allergens'] as String;
      allergenList.add(allergen.toLowerCase());
      alist = allergenList.toString();
    }
    print(selectedUserId);
    safe = await readJsonData(alist);
    return safe;
  }

  Future<bool> readJsonData(String alist) async {
    String jsonData = await rootBundle.loadString('assets/allergens.json');
    Map<String, dynamic> data = json.decode(jsonData);
    int f = 0;
    print(alist);
    bool safe = true;
    List<String> mtitles = [];
    List<String> mwords = [];
    data['allergens'].forEach((value) {
      String title = value["name"];
      List<String> subtitles = List<String>.from(value["alternate"]);
      if (alist.contains(title)) {
        for (var subtitle in subtitles) {
          f = 0;
          for (var word in text!) {
            if (word.contains(subtitle)) {
              mwords.add(word);
              f = 1;
              safe = false;
              break;
            }
          }
          if (f == 1) {
            mtitles.add(title);
          }
        }
      }
    });
    matchingTitles = mtitles;
    matchingwords = mwords;
    print(matchingwords);
    print(matchingTitles);
    return safe;
  }

  Future<void> insertUser(String name, List<String> allergens) async {
    final db = await database;
    final id = await db.insert(
      'users',
      {'name': name, 'allergens': allergens.join(',')},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    selectedUserId = id;
    selectedname = name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedid', id);
    prefs.setString('selectedname', name);
    
  }

  Future<void> deleteUser(String name) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> updateUserSelected(int userId, String name) async {
    selectedUserId = userId;
    selectedname = name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedname', name);
    prefs.setInt('selectedid', userId);
  }

  Future<void> uploadtext(List<String> textfromcam) async {
    text = textfromcam;
  }

  Future<void> updateUserAllergens(int userId, List<String> allergens) async {
    final db = await instance.database;
    await db.update(
      'users',
      {'allergens': allergens.join(',')},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<String>> fetchUserSelectedAllergens(int userId) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      columns: ['allergens'],
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (results.isEmpty) {
      return [];
    }

    final allergensString = results.first['allergens'] as String;
    return allergensString.split(',');
  }
}
