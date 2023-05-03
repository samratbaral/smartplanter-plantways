/*import 'package:flutter/material.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:provider/provider.dart';

import '../realm/realm_services.dart';

class Plants extends StatefulWidget{
  const Plants({super.key});

  @override
  State<Plants> createState() => _PlantsState();
}

class _PlantsState extends State<Plants> {
  @override
  List<PlantUserData> users = [];
  void initState{

  }
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context, listen: false);
    return Scaffold(
      body: ListView.builder(itemBuilder: (context, index){
        return Card(
          child: ListTile(
            title: Text(data),
            
          ),
        );
      }),
    );
  }
}*/