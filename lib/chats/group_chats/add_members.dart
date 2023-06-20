import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group_chat_screen.dart';

class AddMembersINGroup extends StatefulWidget {
  final String groupName, groupId;
  final List membersList;
  const AddMembersINGroup(
      {Key? key,
      required this.groupName,
      required this.groupId,
      required this.membersList})
      : super(key: key);

  @override
  State<AddMembersINGroup> createState() => _AddMembersINGroupState();
}

class _AddMembersINGroupState extends State<AddMembersINGroup> {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _search = TextEditingController();

  List membersList = [];
  @override
  void initState() {
    super.initState();

    membersList = widget.membersList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  void onAddmembers() async {
    membersList.add({
      "name": userMap!['name'],
      "email": userMap!['email'],
      "uid": userMap!['uid'],
      "isAdmin": false,
    });
    print(membersList);
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .update({"members": membersList});

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('groups')
        .doc(widget.groupId)
        .set({"name": widget.groupName, "id": widget.groupId});

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const GroupChatHomeScreen()),
      (route) => false,
    );
  }

//     void onAddMembers() async {
//  bool isAlreadyExist = false;

//     for (int i = 0; i < membersList.length; i++) {
//       if (membersList[i]['uid'] == userMap!['uid']) {
//         isAlreadyExist = true;
//       }
//     }

//     if (!isAlreadyExist) {
//       setState(() {
//         membersList.add({
//           "name": userMap!['name'],
//           "email": userMap!['email'],
//           "uid": userMap!['uid'],
//           "isAdmin": false,
//         });

//          userMap = null;
//       });
//     }
//          Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//         (route) => false,
//       );
//   }

//  void onAddMembers() async {
//     setState(() {
//       isLoading = true;
//     });
//     String groupId = const Uuid().v1();

//     await _firestore
//         .collection('groups')
//         .doc(groupId)
//         .set({"members": widget.membersList, "id": groupId});

//     for (int i = 0; i < widget.membersList.length; i++) {
//       String uid = widget.membersList[i]['uid'];

//       await _firestore
//           .collection('users')
//           .doc(uid)
//           .collection('groups')
//           .doc(groupId)
//           .set({"name":  widget.groupName, "id": groupId});
//     }

//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//         (route) => false);
//   }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Members"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: onSearch,
                    child: const Text("Search"),
                  ),
            userMap != null
                ? ListTile(
                    onTap: onAddmembers,
                    leading: const Icon(Icons.account_circle),
                    title: Text(userMap!['name']),
                    subtitle: Text(userMap!['email']),
                    trailing: const Icon(Icons.add),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
