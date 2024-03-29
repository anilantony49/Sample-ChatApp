import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/chats/create_group/add_members.dart';

import 'group_chat_room.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatHomeScreen> createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

 /* void getAvailableGroups() async {
  String uid = _auth.currentUser!.uid;

  await _firestore
      .collection('users')
      .doc(uid)
      .collection('groups')
      .snapshots()
      .listen((event) {
    setState(() {
      groupList = event.docs;
      isLoading = false;
    });
  });
}*/

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff128C7E),
        title: const Text("Groups"),
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          : groupList.isEmpty
              ? const Center(
                  child: Text("No Groups Created"),
                )
              : ListView.builder(
                  itemCount: groupList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => GroupChatRoom(
                                groupName: groupList[index]['name'],
                                groupChatId: groupList[index]['id'],
                              ))),
                      leading: const Icon(Icons.group),
                      title: Text(groupList[index]['name']),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const AddMembersInGroup())),
        tooltip: "Create Group",
      ),
    );
  }
}
