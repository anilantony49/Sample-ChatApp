import 'package:flutter/material.dart';

import 'single_status_Item.dart';

class StatusTab extends StatelessWidget {
  const StatusTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: const [
                    CircleAvatar(
                        backgroundColor: Color(0xff128C7E),
                        foregroundColor: Color(0xff128C7E),
                        radius: 30,
                        backgroundImage: AssetImage("assets/download.jpg")),
                    Positioned(
                      top: 40,
                      left: 40,
                      child: CircleAvatar(
                        radius: 10,
                        child: Icon(Icons.add, size: 20),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: ListTile(
                    title: Text('My Status'),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text('Tap to add status update'),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Viewed updates',
                  style: TextStyle(fontWeight: FontWeight.w400)),
            ),
            Row(
              children: [
                Stack(
                  children: const [
                    CircleAvatar(
                      //  backgroundColor: Colors.grey,
                      radius: 30,
                      child: CircleAvatar(
                          radius: 28,
                          backgroundImage: AssetImage("assets/download.jpg")),
                    ),
                  ],
                ),
                const Expanded(
                  child: ListTile(
                    title: Text('ANNA'),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text('7 minutes ago'),
                    ),
                  ),
                ),
              ],
            ),
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: const ExpansionTile(
                textColor: Colors.black,
                tilePadding: EdgeInsets.all(0.0),
                title: Text('Muted updates',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
                children: [
                  SingleStatusItem(
                    statusTitle: 'TONI',
                    statusTime: '56 minutes ago',
                    statusImage: 'assets/download.jpg',
                  ),
                  SingleStatusItem(
                    statusTitle: 'PETER',
                    statusTime: '2 minutes ago',
                    statusImage: 'assets/download.jpg',
                  ),
                  SingleStatusItem(
                    statusTitle: 'PAUL',
                    statusTime: '12 minutes ago',
                    statusImage: 'assets/download.jpg',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
