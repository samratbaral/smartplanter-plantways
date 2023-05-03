import 'package:flutter/material.dart';
import 'package:flutter_todo/components/modify_item.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:flutter_todo/realm/realm_services.dart';

enum MenuOption { edit, delete, update}

class TodoItem extends StatelessWidget {
  final PlantUserData plant;

  const TodoItem(this.plant, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    bool isMine = (plant.ownerId == realmServices.currentUser?.id);
    return plant.isValid
        ? ListTile(
      leading: Checkbox(
        value: plant.isComplete,
        onChanged: (bool? value) async {
          if (isMine) {
            await realmServices.updateItem(plant,
                isComplete: value ?? false);
          } else {
            errorMessageSnackBar(context, "Change not allowed!",
                "You are not allowed to change the status of \n tasks that don't belomg to you.")
                .show(context);
          }
        },
      ),
      title: Text(plant.plantName),
      subtitle: Text(
        isMine ? '(smart-planter) ' : '(dummy)',
        style: boldTextStyle(),
      ),

      trailing: SizedBox(
        width: 25,
        child: PopupMenuButton<MenuOption>(
          onSelected: (menuItem) =>
              handleMenuClick(context, menuItem, plant, realmServices),
          itemBuilder: (context) => [
            const PopupMenuItem<MenuOption>(
              value: MenuOption.edit,
              child: ListTile(
                  leading: Icon(Icons.edit), title: Text("Edit Planter")),
            ),
            const PopupMenuItem<MenuOption>(
              value: MenuOption.update,
              child: ListTile(
                  leading: Icon(Icons.update), title: Text("Update Data")),
            ),
            const PopupMenuItem<MenuOption>(
              value: MenuOption.delete,
              child: ListTile(
                  leading: Icon(Icons.delete), title: Text("Delete Planter")),
            ),
          ],
        ),
      ),
      shape: const Border(bottom: BorderSide()),
    )
        : Container();
  }

  void handleMenuClick(BuildContext context, MenuOption menuItem, PlantUserData plant ,
      RealmServices realmServices) {
    bool isMine = (plant.ownerId == realmServices.currentUser?.id);
    switch (menuItem) {
      case MenuOption.edit:
        if (isMine) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => Wrap(children: [ModifyItemForm(plant)]),
          );
        } else {
          errorMessageSnackBar(context, "Edit not allowed!",
              "You are not allowed to edit tasks \nthat don't belong to you.")
              .show(context);
        }
        break;
      case MenuOption.delete:
        if (isMine) {
          realmServices.deleteItem(plant);
        } else {
          errorMessageSnackBar(context, "Delete not allowed!",
              "You are not allowed to delete this plant \n that don't belong to you.")
              .show(context);
        }
        break;
      case MenuOption.update:
        if (isMine) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => Wrap(children: [ModifyItemForm(plant)]),
          );
        } else {
          errorMessageSnackBar(context, "Update not allowed!",
              "You are not allowed to edit tasks \nthat don't belong to you.")
              .show(context);
        }
        break;
    }
  }
}
