import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:flutter_todo/components/widgets.dart';

class ModifyItemForm extends StatefulWidget {
  final PlantUserData plant;
  const ModifyItemForm(this.plant, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ModifyItemFormState createState() => _ModifyItemFormState(plant);
}

class _ModifyItemFormState extends State<ModifyItemForm> {
  final _formKey = GlobalKey<FormState>();
  final PlantUserData plant;
  late TextEditingController _pot_nameController;
  late TextEditingController _pot_plantnameController;
  late ValueNotifier<bool> _isCompleteController;

  _ModifyItemFormState(this.plant);

  @override
  void initState() {
    _pot_nameController = TextEditingController(text: plant.plantName);
    _pot_plantnameController = TextEditingController(text: plant.potName);
    _isCompleteController = ValueNotifier<bool>(plant.isComplete)
      ..addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _pot_nameController.dispose();
    _pot_plantnameController.dispose();
    _isCompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme myTextTheme = Theme.of(context).textTheme;
    final realmServices = Provider.of<RealmServices>(context, listen: false);
    return formLayout(
        context,
        Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Update your Planter", style: myTextTheme.titleLarge),
                TextFormField(
                  controller: _pot_plantnameController,
                  validator: (value) => (value ?? "").isEmpty
                      ? "Please Enter New Pot Name"
                      : null,
                ),
                TextFormField(
                  controller: _pot_nameController,
                  validator: (value) => (value ?? "").isEmpty
                      ? "Please Enter New Plant Name "
                      : null,
                ),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: <Widget>[
                      radioButton("Complete", true, _isCompleteController),
                      radioButton("Incomplete", false, _isCompleteController),
                    ],
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cancelButton(context),
                      deleteButton(context,
                          onPressed: () =>
                              delete(realmServices, plant, context)),
                      okButton(context, "Update",
                          onPressed: () async => await update(
                              context,
                              realmServices,
                              plant,
                              _pot_plantnameController.text,
                              _pot_nameController.text,
                              _isCompleteController.value)),
                    ],
                  ),
                ),
              ],
            )));
  }

  Future<void> update(
      BuildContext context,
      RealmServices realmServices,
      PlantUserData plant,
      String plantName,
      String potName,
      bool isComplete) async {
    if (_formKey.currentState!.validate()) {
      await realmServices.updateItem(plant,
          plantName: plantName, potName: potName, isComplete: isComplete);
      Navigator.pop(context);
    }
  }

  void delete(
      RealmServices realmServices, PlantUserData plant, BuildContext context) {
    realmServices.deleteItem(plant);
    Navigator.pop(context);
  }
}
