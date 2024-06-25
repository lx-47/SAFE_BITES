import 'package:flutter/material.dart';
import 'database.dart';
import 'feedback.dart';
import 'home.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

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
      body: const Users(),
    );
  }
}

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final dbHelper = Db.instance;
  late List<String> userList;
  late String? selectedUser = Db.selectedname;

  @override
  void initState() {
    super.initState();
    userList = [];
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final users = await dbHelper.getUsers();
    setState(() {
      userList = users.map<String>((user) => user['name'] as String).toList();
    });
  }

  void addUser(String username) async {
    await dbHelper.insertUser(username, []);
    _fetchUsers();
  }

  void selectUser(String username) async {
    setState(() {
      selectedUser = username;
    });

    // Fetch the selected user's ID from the database
    final db = await Db.instance.database;
    final results = await db.query(
      'users',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [username],
    );

    if (results.isNotEmpty) {
      final selectedUserId = results.first['id'] as int;
      await Db.instance.updateUserSelected(
          selectedUserId, username);
      print('Selected user: $username (ID: $selectedUserId)');
    } else {
      print('Selected user not found in the database');
    }
  }

  void deleteUser(String username) async {
    await dbHelper.deleteUser(username);
    _fetchUsers();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset('assets/images/backarrow.png'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(selectedUser: selectedUser),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedBackPage(),
                ),
              );
            },
            icon: Image.asset('assets/images/Comments.png'),
          ),
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
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final username = userList[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 10,
                    top: 10,
                  ),
                  child: Dismissible(
                    key: Key(username),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                            'Are you sure you want to delete this user?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                deleteUser(username);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Container(
                      color: selectedUser == username
                          ? const Color(0xFFA2F693)
                          : null,
                      child: ListTile(
                        onTap: () {
                          selectUser(username);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(selectedUser: selectedUser),
                            ),
                          );
                        },
                        leading: const Icon(Icons.person),
                        title: Text(username),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'Are you sure you want to delete this user?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      deleteUser(username);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _AddUserDialog(
                    onAddUser: addUser,
                  ),
                );
              },
              icon: const Icon(Icons.person),
              label: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddUserDialog extends StatefulWidget {
  final Function(String) onAddUser;

  const _AddUserDialog({required this.onAddUser});

  @override
  __AddUserDialogState createState() => __AddUserDialogState();
}

class __AddUserDialogState extends State<_AddUserDialog> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add User'),
      content: TextField(
        controller: _usernameController,
        decoration: const InputDecoration(labelText: 'Username'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String username = _usernameController.text;
            widget.onAddUser(username);
            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
