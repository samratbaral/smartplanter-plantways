import 'package:flutter/material.dart';
import 'package:flutter_todo/components/user_info_class.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({
    super.key,
    required this.box,
  });
  final UserInfoClass box;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 5),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(box.imagePath),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('username: ${box.username}'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text('email: ${box.email}'),
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: Text('password: ${box.password}'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
