import 'package:flutter/material.dart';

class SingleChatWidget extends StatelessWidget {
  final String? chatMessage;
  final String? chatTitle;
  final Color? seenStatusColor;
  final String? assetsimage;
  final String? messeges;
  final String? dateOrtime;

  const SingleChatWidget({
    Key? key,
    this.chatMessage,
    this.chatTitle,
    this.seenStatusColor,
    this.assetsimage,
    this.messeges,
    this.dateOrtime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(assetsimage!),
        ),
        Expanded(
          child: ListTile(
            title: Text('$chatTitle',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Row(children: [
              Icon(
                seenStatusColor == Colors.blue ? Icons.done_all : Icons.done,
                size: 15,
                color: seenStatusColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    '$chatMessage',
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ]),
            trailing: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    dateOrtime!,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 10,
                  child: Stack(
                    children: [Text(messeges!)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
