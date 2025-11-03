import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usertrack/screens/auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.sort = 'creationDate'});

  final String sort;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String selectedSort;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.sort;
    print('selected sort: $selectedSort');
    print('sort: ${widget.sort}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.black54),
        elevation: 4,
        centerTitle: true,
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            print('exiting settings');
            Navigator.pop(context, selectedSort);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      // body
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Style',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15),

            // select sort
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sort Notes'),
                DropdownButton<String>(
                  value: selectedSort,
                  items: [
                    // creation date
                    DropdownMenuItem(
                      value: 'creationDate',
                      child: Text('Creation Date'),
                    ),

                    DropdownMenuItem(
                      value: 'modificationDate',
                      child: Text('Modification Date'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        selectedSort = v;
                      });
                    }
                    print('selected sort: $selectedSort');
                    print('sort: ${widget.sort}');
                  },
                ),
              ],
            ),
            SizedBox(height: 15),
            Divider(thickness: 0.8, color: Colors.black54),
            SizedBox(height: 15),
            Text(
              'Account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 15),

            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // password change
                  MaterialButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: FirebaseAuth.instance.currentUser!.email!,
                      );
                    },
                    color: Colors.blue,
                    child: Text('Change Password'),
                  ),

                  // Delete Account
                  MaterialButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.currentUser!.delete();

                      CollectionReference users = FirebaseFirestore.instance
                          .collection('users');

                      QuerySnapshot usersDocs = await users.get();

                      List<QueryDocumentSnapshot> user = usersDocs.docs;

                      for (int i = 0; i < user.length; i++) {
                        if (user[i]['uid'] ==
                            FirebaseAuth.instance.currentUser!.uid) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user[i].id)
                              .delete();
                        }
                      }

                      // push a new screen and remove all previous routes
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    color: Colors.red,
                    child: Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),

                  // logout
                  MaterialButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      // push a new screen and remove all previous routes
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    color: Colors.red,
                    child: Text('Logout', style: TextStyle(fontSize: 15)),
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
