import 'package:flutter/material.dart';
import 'package:flutter_todo/components/user_info_class.dart';

class UserUpdateWidget extends StatefulWidget {
  const UserUpdateWidget({
    super.key,
    required this.box2,
  });
  final UserInfoClass box2;
  @override
  State<UserUpdateWidget> createState() => _UserUpdateWidgetState();
}

// TODO: Change the password and username/email. Need implementation from Realm
//TODO: https://www.mongodb.com/docs/realm/sdk/flutter/users/email-password-users/

class _UserUpdateWidgetState extends State<UserUpdateWidget> {
  final _emailcontroller = TextEditingController();
  final _pswcontroller = TextEditingController();
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
              backgroundImage: AssetImage(widget.box2.imagePath),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailcontroller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter new email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pswcontroller,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter new password",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 130, 197, 91),
                ),
              ),
              onPressed: () {
                setState(() {
                  widget.box2.email = _emailcontroller.text;
                  widget.box2.password = _pswcontroller.text;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Save Successful'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
