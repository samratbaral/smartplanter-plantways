import 'package:flutter/material.dart';
import 'package:flutter_todo/components/user_info_class.dart';

class UserUpdateWidget extends StatelessWidget {
  const UserUpdateWidget({
    super.key,
    required this.box2,
  });
  final UserInfoClass box2;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(box2.imagePath),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: box2.username,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: box2.email,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: box2.password,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
