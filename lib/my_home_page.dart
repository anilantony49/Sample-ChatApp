
import 'package:flutter/Cupertino.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp/callls/call_page.dart';
import 'package:whatsapp/status/status_page.dart';
import 'chats/chats_tab.dart';
import 'methods.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Map<String, dynamic>? userMap;
  // bool _searching = false;
  // bool isLoading = false;
  // final TextEditingController _search = TextEditingController();
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // late TabController _tabController;

//    void initState() {
//   super.initState();
//   _tabController = TabController(length: 3, vsync: this); // change 3 to the number of tabs you need
// }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  // String chatRoomId(String user1, String user2) {
  //   if (user1[0].toLowerCase().codeUnits[0] >
  //       user2.toLowerCase().codeUnits[0]) {
  //     return "$user1$user2";
  //   } else {
  //     return "$user2$user1";
  //   }
  // }

  // void onSearch() async {
  //   final size = MediaQuery.of(context).size;
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   await _firestore
  //       .collection('users')
  //       .where("email", isEqualTo: _search.text)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       userMap = value.docs[0].data();
  //       isLoading = false;
  //     });

  //     print("fa");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            //   Tooltip(
            //     message: "Search",
            //     child: IconButton(
            //       icon: const Icon(Icons.search),
            //       onPressed: () {
            //         setState(() {
            //           _searching = !_searching;
            //         });

            //         if (_search.text.isNotEmpty) {
            //           onSearch();

            //           // ChatsTab();
            //         } else {
            //           return;
            //         }
            //       },
            //     ),
            //   ),
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
                          child: Text("Log Out")))
                ];
              },
            ),
          ],
          backgroundColor: const Color(0xff128C7E),
          title: const Text('WhatsApp'),
          //  AnimatedSwitcher(
          //   duration: Duration(milliseconds: 300),
          //   child: _searching
          //       ? TextField(
          //           controller: _search,
          //           decoration: const InputDecoration(
          //             hintText: 'Search...',
          //             hintStyle: TextStyle(color: Colors.white54),
          //             border: InputBorder.none,
          //           ),
          //           style: TextStyle(color: Colors.white),
          //         )
          //       : Text('WhatsApp'),
          // ),
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
        ),

        // appBar:const PreferredSize(
        //   child: AppbarWidget(),
        //   preferredSize:Size.fromHeight(150),) ,
        body: TabBarView(
          //  controller: _tabController,
          children: [
            // Center(child: Text('This feature is coming soon')),
            ChatsTab(),

            const StatusTab(),
            const CallTab(),
          ],
        ),

        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.group), onPressed: () async {}),
      ),
    );
  }
}
