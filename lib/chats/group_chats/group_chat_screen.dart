import 'package:flutter/material.dart';
import 'package:whatsapp/chats/create_group/add_members.dart';

import 'group_chat_room.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<GroupChatHomeScreen> createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff128C7E),
        title: Text("Groups"),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => GroupChatRoom())),
            leading: Icon(Icons.group),
            title: Text("Group $index"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddMembersInGroup())),
        tooltip: "Create Group",
      ),
    );
  }
}
