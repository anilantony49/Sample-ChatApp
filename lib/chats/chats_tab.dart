import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:whatsapp/chats/group_chats/chat_room.dart';

import '../callls/call_page.dart';
import '../methods.dart';
import '../status/status_page.dart';
import 'group_chats/group_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;

  bool _searching = false;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
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
    if (user1.toLowerCase().compareTo(user2.toLowerCase()) > 0) {
      return "$user2$user1";
    } else {
      return "$user1$user2";
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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(115.0),
          child: AppBar(
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
              PopupMenuButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(child: Text('New Group')),
                    const PopupMenuItem(child: Text('New Broadcast')),
                    const PopupMenuItem(child: Text('Linked Devices')),
                    const PopupMenuItem(child: Text('Starred Messages')),
                    const PopupMenuItem(child: Text('Settings')),
                    PopupMenuItem(
                        child: TextButton(
                            onPressed: () {
                              logOut(context);
                            },
                            child: const Text("Log Out")))
                  ];
                },
              ),
              // Tooltip(
              //   message: "Search",
              //   child: IconButton(
              //     icon: const Icon(Icons.search),
              //     onPressed: () {
              //       setState(() {
              //         _searching = !_searching;
              //       });

              //       if (_search.text.isNotEmpty) {
              //         onSearch();

              //         // ChatsTab();
              //       } else {
              //         return;
              //       }
              //     },
              //   ),
              // ),
            ],
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _searching
                  ? TextField(
                      controller: _search,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                    )
                  : const Text('WhatsApp'),
            ),
            //  title: const Text('WhatsApp'),
            bottom: const TabBar(
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              tabs: [
                // Tab(
                //     iconMargin: EdgeInsets.all(100),
                //     child: Icon(
                //       Icons.camera_alt_rounded,
                //     )),
                Tab(
                  child: Text('CHATS', style: TextStyle(color: Colors.white)),
                ),
                Tab(
                  child: Text('STATUS', style: TextStyle(color: Colors.white)),
                ),
                Tab(
                  child: Text('CALLS', style: TextStyle(color: Colors.white)),
                ),
              ],
              labelColor: Colors.white,
            ),

            // title: AnimatedSwitcher(
            //   duration: const Duration(milliseconds: 300),
            //   child: _searching
            //       ? TextField(
            //           controller: _search,
            //           decoration: const InputDecoration(
            //             hintText: 'Search...',
            //             hintStyle: TextStyle(color: Colors.white54),
            //             border: InputBorder.none,
            //           ),
            //           style: const TextStyle(color: Colors.white),
            //         )
            //       : const Text('WhatsApp'),
            // ),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoScrollbar(
                  child: ListView(
                    children: [
                      isLoading
                          ? Center(
                              child: CupertinoScrollbar(
                                child: SizedBox(
                                  height: size.height / 20,
                                  width: size.height / 20,
                                  child: const CircularProgressIndicator(),
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
                                        // selectedColor: Colors.blue,
                                        tileColor: Colors.grey[300],
                                        trailing: const Icon(Icons.chat,
                                            color: Colors.black),
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
                )),

            // StatusTab(),

            const StatusTab(),
            const CallTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.group),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GroupChatHomeScreen())),
        ),
      ),
    );
  }
}
