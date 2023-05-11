// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_todo/realm/app_services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/realm_services.dart';

class TodoAppBar extends StatelessWidget with PreferredSizeWidget {
  TodoAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 130, 197, 91),
      title: const Text('             Smart Planter'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        //bluetooth_connected
        IconButton(
          icon: Icon(realmServices.offlineModeOn
              ? Icons.wifi_off_rounded
              : Icons.wifi_rounded),
          color: Colors.black,
          tooltip: 'Offline mode',
          onPressed: () async => await realmServices.sessionSwitch(),
        ),
        IconButton(
          icon: Icon(realmServices.offlineModeOn
              ? Icons.bluetooth_disabled
              : Icons.bluetooth_connected),
          color: Colors.black,
          tooltip: 'Offline mode',
          onPressed: () async => await realmServices.sessionSwitch(),
        ),
        // IconButton(
        //   icon: const Icon(Icons.logout),
        //   color: Colors.black,
        //   tooltip: 'Log out',
        //   onPressed: () async => await logOut(context, realmServices),
        // ),
      ],
    );
  }

  Future<void> logOut(BuildContext context, RealmServices realmServices) async {
    final appServices = Provider.of<AppServices>(context, listen: false);
    appServices.logOut();
    await realmServices.close();
    Navigator.pushNamed(context, '/welcome');
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
