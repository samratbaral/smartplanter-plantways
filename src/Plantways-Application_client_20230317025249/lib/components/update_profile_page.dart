import 'package:flutter/material.dart';
import 'package:flutter_todo/components/user_update_widget.dart';
import 'package:flutter_todo/components/user_info_class.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({
    super.key,
  });

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Account'),
        backgroundColor: const Color.fromARGB(255, 130, 197, 91),
      ),
      body: Column(
        children: [
          UserUpdateWidget(box2: userInfo),
          const SizedBox(height: 20),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                Color.fromARGB(255, 130, 197, 91),
              ),
            ),
            onPressed: () {
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
    );
  }
}
