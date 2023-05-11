import 'package:flutter/material.dart';
import 'package:flutter_todo/components/update_profile_page.dart';
import 'package:flutter_todo/components/user_info_class.dart';
import 'package:flutter_todo/realm/app_services.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:provider/provider.dart';

class UserCardWidget extends StatefulWidget {
  const UserCardWidget({
    super.key,
    required this.box,
  });
  final UserInfoClass box;
  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 5),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(widget.box.imagePath),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text('email: ${widget.box.email}'),
            ),
            // ListTile(
            //   leading: const Icon(Icons.key),
            //   title: Text('password: ${widget.box.password}'),
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 130, 197, 91),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const UpdateProfilePage();
                    },
                  ),
                );
              },
              child: const Text('Update Account'),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Color.fromARGB(255, 130, 197, 91),
                ),
              ),
              onPressed: () async {
                await logOut(context, realmServices);
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> logOut(BuildContext context, RealmServices realmServices) async {
  final appServices = Provider.of<AppServices>(context, listen: false);
  appServices.logOut();
  await realmServices.close();
  Navigator.pushNamed(context, '/welcome');
}
