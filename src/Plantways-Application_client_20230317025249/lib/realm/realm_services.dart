import 'package:flutter_todo/realm/schemas.dart';
import 'package:realm/realm.dart';
import 'package:flutter/material.dart';

class RealmServices with ChangeNotifier {
  static const String queryAllName = "getAllItemsSubscription";
  static const String queryMyItemsName = "getMyItemsSubscription";

  bool showAll = false;
  bool offlineModeOn = false;
  bool isWaiting = false;
  late Realm realm;
  User? currentUser;
  App app;

  RealmServices(this.app) {
    if (app.currentUser != null || currentUser != app.currentUser) {
      currentUser ??= app.currentUser;
      realm = Realm(Configuration.flexibleSync(currentUser!, [PlantUserData.schema ]));
      // showAll = (realm.subscriptions.findByName(queryAllName) != null);
      // if (realm.subscriptions.isEmpty) {
      //   updateSubscriptions();
      // }
    }
  }

  Future<void> updateSubscriptions() async {
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
      if (showAll) {
        mutableSubscriptions.add(realm.all<PlantUserData>(), name: queryAllName);
      } else {
        mutableSubscriptions.add(
            realm.query<PlantUserData>(r'owner_id == $0', [currentUser?.id]),
            name: queryMyItemsName);
      }
    });
    await realm.subscriptions.waitForSynchronization();
  }

  Future<void> sessionSwitch() async {
    offlineModeOn = !offlineModeOn;
    if (offlineModeOn) {
      realm.syncSession.pause();
    } else {
      try {
        isWaiting = true;
        notifyListeners();
        realm.syncSession.resume();
        await updateSubscriptions();
      } finally {
        isWaiting = false;
      }
    }
    notifyListeners();
  }

  Future<void> switchSubscription(bool value) async {
    showAll = value;
    if (!offlineModeOn) {
      try {
        isWaiting = true;
        notifyListeners();
        await updateSubscriptions();
      } finally {
        isWaiting = false;
      }
    }
    notifyListeners();
  }

  void createUser(
      String potPlantname,
      String potMacAdrress,
      int humidity,
      int temperature,
      String soilMoisture,
      String lightIntensity,
      String waterTankLevel,
      String levelSensor) async {
    //  if (realm.subscriptions.isEmpty) {
    await updateSubscriptions();
    //   }

    realm.subscriptions.update((MutableSubscriptionSet mutableSubscriptions) {
      final newItem = PlantUserData(ObjectId(),
          isComplete: false,
          username: currentUser!.id,
          pot_plantname: potPlantname,
          pot_mac_adrress: potMacAdrress,
          humidity: humidity,
          temperature: temperature,
          soilMoisture: soilMoisture,
          lightIntensity: lightIntensity,
          waterTankLevel: waterTankLevel,
          levelSensor: levelSensor);

      realm.write<PlantUserData>(() => realm.add<PlantUserData>(newItem));
      realm.subscriptions.waitForSynchronization();
    });

    notifyListeners();
  }

//
// void createItem(String summary, bool isComplete) {
//     final newItem =
//     PlantUserData(ObjectId(), summary, currentUser!.id, isComplete: isComplete);
//     realm.write<PlantUserData>(() => realm.add<PlantUserData>(newItem));
//     notifyListeners();
//   }

  // void createItem(String username, DateTime dateLastServiced, bool isComplete, List<Pot>plantPotList) {
  //   final newPlant = PlantUser(ObjectId(), username, dateLastServiced, currentUser!.id, isComplete: isComplete, );
  //   realm.write<PlantUser>(() => realm.add<PlantUser>(newPlant));
  //   notifyListeners();
  // }



  void deleteItem(PlantUserData plantUser) {
    realm.write(() => realm.delete(plantUser));
    notifyListeners();
  }

  Future<void> updateItem(PlantUserData item,
      {String? summary, bool? isComplete}) async {
    realm.write(() {
    });
    notifyListeners();
  }

  Future<void> close() async {
    if (currentUser != null) {
      await currentUser?.logOut();
      currentUser = null;
    }
    realm.close();
  }

  @override
  void dispose() {
    realm.close();
    super.dispose();
  }
}
