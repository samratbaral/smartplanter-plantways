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
      realm = Realm(
          Configuration.flexibleSync(currentUser!, [PlantUserData.schema]));
      showAll = (realm.subscriptions.findByName(queryAllName) != null);
      if (realm.subscriptions.isEmpty) {
        updateSubscriptions();
      }
    }
  }

  Future<void> updateSubscriptions() async {
    realm.subscriptions.update((mutableSubscriptions) {
      mutableSubscriptions.clear();
<<<<<<< HEAD
      if (showAll) {
        mutableSubscriptions.add(realm.all<PlantUserData>(),
            name: queryAllName);
      } else {
        mutableSubscriptions.add(
            realm.query<PlantUserData>(r'owner_id == $0', [currentUser?.id]),
            name: queryMyItemsName);
      }
=======
      mutableSubscriptions.add(realm.all<PlantUserData>(), name: queryAllName, update: true);
>>>>>>> 26750efd1f1ff59228096e8e0b921e53141aeedf
    });
    //await realm.subscriptions.waitForSynchronization();
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

<<<<<<< HEAD
  Future<void> createItem(String plantName, bool isComplete, String potName,
      String potMac, Set<String> sensorData, List<String> potConnect) async {
    final newItem = PlantUserData(
        ObjectId(), potName, plantName, potMac, currentUser!.id,
        potSensorData: sensorData,
        isComplete: isComplete,
        potConnection: potConnect);
    realm.write<PlantUserData>(() => realm.add<PlantUserData>(newItem));
=======
// String potPlantname,
//       String potMacAdrress,
//       int humidity,
//       int temperature,
//       String soilMoisture,
//       String lightIntensity,
//       String waterTankLevel,
//       String levelSensor)
  void createUser(
    int humidity,
    String levelSensor,
    String lightIntensity,
    String potMacAdrress,
    String potPlantname,
    String soilMoisture,
    int temperature,
    String waterTankLevel,
  ) async {
    //  if (realm.subscriptions.isEmpty) {
    await updateSubscriptions();
    //   }
    realm.write(() {
      realm.add(PlantUserData(
        ObjectId(),
        humidity: humidity,
        false,
        levelSensor: levelSensor,
        lightIntensity: lightIntensity,
        potMacAdrress: potMacAdrress,
        potPlantname: potPlantname,
        soilMoisture: soilMoisture,
        temperature: temperature,
        username: currentUser!.id,
        waterTankLevel: waterTankLevel,
      ));
    });
    // realm.subscriptions.update((MutableSubscriptionSet mutableSubscriptions) {
    //   final newItem = PlantUserData(
    //     ObjectId(),
    //     humidity: humidity,
    //     false,
    //     levelSensor: levelSensor,
    //     lightIntensity: lightIntensity,
    //     potMacAdrress: potMacAdrress,
    //     potPlantname: potPlantname,
    //     soilMoisture: soilMoisture,
    //     temperature: temperature,
    //     username: currentUser!.id,
    //     waterTankLevel: waterTankLevel,
    //   );

    //   realm.write<PlantUserData>(() => realm.add<PlantUserData>(newItem));
    //   realm.subscriptions.waitForSynchronization();
    // });
    realm.subscriptions.waitForSynchronization();
>>>>>>> 26750efd1f1ff59228096e8e0b921e53141aeedf
    notifyListeners();
  }

  void deleteItem(PlantUserData plantUser) {
    realm.write(() => realm.delete(plantUser));
    notifyListeners();
  }

  // Future<void> updateItem(PlantUserData item,
  //     {String? summary, bool? isComplete}) async {
  //   realm.write(() {
  //   });
  //   notifyListeners();
  // }

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
