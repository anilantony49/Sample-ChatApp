import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:whatsapp/chats/chats_tab.dart';

import 'package:whatsapp/login_screen.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Authenticate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
