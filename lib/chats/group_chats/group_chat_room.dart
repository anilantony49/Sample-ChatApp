import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group_info.dart';

class GroupChatRoom extends StatelessWidget {
  GroupChatRoom({Key? key}) : super(key: key);

  final TextEditingController _message = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff128C7E),
        title: const Text("Group Name"),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const GroupInfo())),
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: size.height / 1.27,
            width: size.width,
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return null;
                }),
          ),
          Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: SizedBox(
              height: size.height / 12,
              width: size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height / 17,
                    width: size.width / 1.3,
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () => {},
                              icon: const Icon(Icons.photo)),
                          hintText: "Send Message",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.send))
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(
      builder: (_) {
        if (chatMap['sendBy'] == "text") {
          return Container(
            width: size.width,
            alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue),
                child: Column(
                  children: [
                    Text(
                      chatMap['sendBy'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: size.height / 200,
                    ),
                    Text(
                      chatMap['message'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          );
        } else if (chatMap['type'] == "img") {
          return Container(
            width: size.width,
            alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                height: size.height / 2,
                child: Image.network(
                  chatMap['message'],
                )),
          );
        } else if (chatMap['type'] == "notify") {
          return Container(
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black38,
              ),
              child: Text(
                chatMap['message'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
