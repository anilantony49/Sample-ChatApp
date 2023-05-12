import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/chats/chats_tab.dart';

import 'add_members.dart';

class GroupInfo extends StatefulWidget {
  final String groupName, groupId;
  const GroupInfo({Key? key, required this.groupName, required this.groupId})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List membersList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getGroupDetails();
  }


 Future getGroupDetails() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((chatMap) {
      setState(() {
        membersList = chatMap['members'];
        print(membersList);
        isLoading = false;
      });
    });
  }
  bool checkAdmin() {
    bool isAdmin = false;

    membersList.forEach((element) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });

    return isAdmin;
  }

    Future removeMembers(int index) async {
    String uid = membersList[index]['uid'];

    setState(() {
      isLoading = true;
      membersList.removeAt(index);
    });

    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    }).then((value) async {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      setState(() {
        isLoading = false;
      });
    });
  }
    void showDialogBox(int index) {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != membersList[index]['uid']) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: ListTile(
                  onTap: () {
                     removeMembers(index);
                   Navigator.of(context).pop();
                  },
                  title: const Text("Remove This Member"),
                  
                ),
                
              );
            });
      }
    }
  }

  Future onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });

      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == _auth.currentUser!.uid) {
          membersList.removeAt(i);
        }
      }

      await _firestore.collection('groups').doc(widget.groupId).update({
        "members": membersList,
      });

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }
  }

 

  // void showRemoveDialog(int index) {
  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return AlertDialog(
  //           content: ListTile(
  //             onTap: () => removeUser(index),
  //             title: const Text("Remove This User"),
  //           ),
  //         );
  //       });
  // }

  // void removeUser(int index) async {
  //   if (checkAdmin()) {
  //     if (_auth.currentUser!.uid != membersList[index]['uid']) {}
  //   } else {
  //     print("can't remove");
  //   }
  // }

  // Future<void> onLeaveGroup() async {
  //   if (checkAdmin()) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     String uid = _auth.currentUser!.uid;

  //     for (int i = 0; i < membersList.length; i++) {
  //       if (membersList[i]['uid'] == uid) {
  //         membersList.remove(i);
  //       }
  //     }

  //     await _firestore.collection('groups').doc(widget.groupId).update({
  //       "members": membersList,
  //     });

  //     await _firestore
  //         .collection('users')
  //         .doc(uid)
  //         .collection('groups')
  //         .doc(widget.groupId)
  //         .delete();

  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (_) => const HomeScreen()),
  //         (route) => false);
  //   } else {
  //     print("Can't left group");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Container(
                height: size.height,
                width: size.width,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft, child: BackButton()),
                    SizedBox(
                      height: size.height / 8,
                      width: size.width / 1.1,
                      child: Row(
                        children: [
                          Container(
                              height: size.height / 11,
                              width: size.width / 11,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              child: Icon(
                                Icons.group,
                                color: Colors.white,
                                size: size.width / 10,
                              )),
                          SizedBox(
                            width: size.width / 20,
                          ),
                          Expanded(
                              child: Text(
                            widget.groupName,
                            style: TextStyle(
                                fontSize: size.width / 16,
                                fontWeight: FontWeight.w500),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    SizedBox(
                      width: size.width / 1.1,
                      child: Text(
                        "${membersList.length} Members",
                        style: TextStyle(
                            fontSize: size.width / 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                    SizedBox(
                      height: size.height / 20,
                    ),

                    checkAdmin()
                        ? ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddMembersINGroup(
                                  groupId: widget.groupId,
                                  groupName: widget.groupName,
                                  membersList: membersList,
                                ),
                              ),
                            ),
                            leading: const Icon(
                              Icons.add,
                            ),
                            title: Text(
                              "Add Members",
                              style: TextStyle(
                                fontSize: size.width / 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : const SizedBox(),

                    // Members Name

                    Flexible(
                        child: ListView.builder(
                            itemCount: membersList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () => showDialogBox(index),
                                leading: const Icon(Icons.account_circle),
                                title: Row(
                                  children: [
                                    Text(
                                      membersList[index]['name'],
                                      style: TextStyle(
                                          fontSize: size.width / 22,
                                          fontWeight: FontWeight.w500),
                                    ),
                                     Text(membersList[index]['isAdmin']
                                    ?"  (you)" 
                                    : "")
                                  ],
                                ),
                                subtitle: Text(membersList[index]['email']),
                                trailing: Text(membersList[index]['isAdmin']
                                    ?"Admin"
                                    : ""),
                              );
                            })),

                    ListTile(
                        onTap: onLeaveGroup,
                        leading:
                            const Icon(Icons.logout, color: Colors.redAccent),
                        title: Text("Leave Group",
                            style: TextStyle(
                                fontSize: size.width / 22,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 86, 72, 72))))
                  ],
                ),
              ),
      ),
    );
  }
}
