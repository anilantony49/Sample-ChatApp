import 'package:flutter/material.dart';
import 'package:flutter/Cupertino.dart';
import 'package:whatsapp/chats/single_chat_widget.dart'; //

class ChatsTab extends StatelessWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoScrollbar(
          child: ListView(
            children: const [
              SingleChatWidget(
                  chatTitle: "PETER",
                  chatMessage: 'Hi',
                  seenStatusColor: Colors.blue,
                  assetsimage: 'assets/download.jpg',
                  messeges: "2",
                  dateOrtime: "03:45"),
              SingleChatWidget(
                  chatTitle: "GEORGE",
                  chatMessage: 'Hello',
                  seenStatusColor: Colors.grey,
                  assetsimage: 'assets/download.jpg',
                  messeges: "8",
                  dateOrtime: "06:34"),
              SingleChatWidget(
                  chatTitle: "TOM",
                  chatMessage: 'Hi',
                  seenStatusColor: Colors.grey,
                  assetsimage: 'assets/download.jpg',
                  messeges: "6",
                  dateOrtime: "07:34"),
              SingleChatWidget(
                chatTitle: "ANNA",
                chatMessage: 'How are you?',
                seenStatusColor: Colors.blue,
                assetsimage: 'assets/download.jpg',
                messeges: "1",
                dateOrtime: "1/2/22",
              ),
              SingleChatWidget(
                  chatTitle: "SAM",
                  chatMessage: 'Where are you?',
                  seenStatusColor: Colors.grey,
                  assetsimage: 'assets/download.jpg',
                  messeges: "3",
                  dateOrtime: "4/6/22"),
              SingleChatWidget(
                  chatTitle: "ARJUN",
                  chatMessage: 'I wish GoT had better ending',
                  seenStatusColor: Colors.blue,
                  assetsimage: 'assets/download.jpg',
                  messeges: "4",
                  dateOrtime: "1/3/22"),
              SingleChatWidget(
                  chatTitle: "HARRY",
                  chatMessage: 'Hi',
                  seenStatusColor: Colors.blue,
                  assetsimage: 'assets/download.jpg',
                  messeges: "2",
                  dateOrtime: "6/2/22"),
              SingleChatWidget(
                  chatTitle: "PAUL",
                  chatMessage: 'Hello',
                  seenStatusColor: Colors.blue,
                  assetsimage: 'assets/download.jpg',
                  messeges: "2",
                  dateOrtime: "1/6/22"),
            ],
          ),
        ),
      ),
    );
  }
}
