import 'package:flutter/material.dart';
import 'package:flutter_todo/components/update_profile_page.dart';
import 'package:flutter_todo/components/user_card_widget.dart';
import 'package:flutter_todo/components/user_info_class.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
  });
//im trying to pass username email and password as values to other pages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        backgroundColor: const Color.fromARGB(255, 130, 197, 91),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          UserCardWidget(box: userInfo),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
