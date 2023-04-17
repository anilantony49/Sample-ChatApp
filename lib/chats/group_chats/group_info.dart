import 'package:flutter/material.dart';

class GroupInfo extends StatelessWidget {
  const GroupInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(alignment: Alignment.centerLeft, child: BackButton()),
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
                      "Group Name",
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
                  "",
                  style: TextStyle(
                      fontSize: size.width / 20, fontWeight: FontWeight.w500),
                ),
              ),

              SizedBox(
                height: size.height / 20,
              ),

              // Members Name

              Flexible(
                  child: ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text(
                            "",
                            style: TextStyle(
                                fontSize: size.width / 22,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      })),

              ListTile(
                onTap: () {},
                leading: const Icon(Icons.logout, color: Colors.redAccent),
              ),

              ListTile(
                  title: Text("Leave Group",
                      style: TextStyle(
                          fontSize: size.width / 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent)))
            ],
          ),
        ),
      ),
    );
  }
}
