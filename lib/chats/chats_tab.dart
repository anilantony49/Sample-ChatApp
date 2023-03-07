import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:whatsapp/chat_room.dart';
import 'package:whatsapp/chats/single_chat_widget.dart';
import '../methods.dart';

class ChatsTab extends StatefulWidget {
  ChatsTab({Key? key}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;

  bool _searching = false;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initstate() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
             actions: [
            Tooltip(
              message: "Search",
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _searching = !_searching;
                  });

                  if (_search.text.isNotEmpty) {
                    onSearch();

                    
                    // ChatsTab();
                  } else {
                    return;
                  }
                },
              ),
            ),
            // PopupMenuButton(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(18),
            //   ),
            //   itemBuilder: (context) {
            //     return [
            //       const PopupMenuItem(child: Text('New Group')),
            //       const PopupMenuItem(child: Text('New Broadcast')),
            //       const PopupMenuItem(child: Text('Linked Devices')),
            //       const PopupMenuItem(child: Text('Starred Messages')),
            //       const PopupMenuItem(child: Text('Settings')),
            //       PopupMenuItem(
            //           child: TextButton(
            //               onPressed: () {
            //                 logOut(context);
            //               },
            //               child: Text("Log Out")))
            //     ];
            //   },
            // ),
          ],
          backgroundColor: const Color(0xff128C7E),
          title: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _searching
                ? TextField(
                    controller: _search,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  )
                : Text('WhatsApp'),
          ),
      ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoScrollbar(
              child: ListView(
                children: [
                  isLoading
                      ? Center(
                          child: CupertinoScrollbar(
                            child: Container(
                              height: size.height / 20,
                              width: size.height / 20,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: size.height / 50,
                            ),

                            userMap != null
                                ? ListTile(
                                    onTap: () {
                                      String roomId = chatRoomId(
                                          _auth.currentUser!.displayName!,
                                          userMap!['name']);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => ChatRoom(
                                                    chatRoomId: roomId,
                                                    userMap: userMap!,
                                                  )));
                                    },
                                     trailing: const Icon(Icons.chat, color: Colors.black),
                                    leading: const Icon(Icons.account_box,
                                        color: Colors.black),
                                    title: Text(
                                      userMap!['name'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(userMap!['email']),
                                  )
                                  
                                : Container(), //
                          ],
                        ),
                ],
              ),
            )
            
            )
            
            );
  }
}
