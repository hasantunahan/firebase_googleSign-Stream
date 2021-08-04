import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseoauth2/Session.dart';
import 'package:firebaseoauth2/model.dart';
import 'package:firebaseoauth2/page/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

class MyHome extends StatefulWidget {
  MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final googleSignIn = GoogleSignIn();
  Future<bool> signInWithGoogle() async {
    final user = await googleSignIn.signIn();
    if (user == null) {
      return false;
    } else {
      final googleAuth = await user.authentication;
      Sessions.image = user.photoUrl;
      Sessions.fireId = user.id;
      Sessions.displayName = user.displayName;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {});
      return true;
    }
  }

  addNewData() {
    var uuid = Uuid();
    print(uuid.v1());
    FirebaseFirestore.instance
        .collection('data')
        .add({"id": uuid.v1().toString(), "name": "hello"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  addNewData();
                },
                child: Text("Add new Data")),
            TextButton(
                onPressed: () {
                  signInWithGoogle();
                },
                child: Text("Login with Google")),
            Image.network(
                FirebaseAuth.instance.currentUser?.photoURL.toString() ?? ""),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('test').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                } else {
                  return Flexible(
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        final docsTime =
                            snapshot.data?.docs[index].get('timestamp');
                        final data = (docsTime as Timestamp).toDate();
                        return ListTile(
                          title: Text(data.toString()),
                          leading: Icon(Icons.ac_unit_outlined),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FirebaseFirestore.instance
              .collection('test')
              .add({'timestamp': Timestamp.fromDate(DateTime.now())});
          //  addNewData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
