import 'package:realm/realm.dart';
part 'schemas.g.dart';

@RealmModel()
class _PlantUserData {
  @MapTo('_id')
  @PrimaryKey()
  late ObjectId id;
  bool isComplete = false;
  late String plantName;
  late String potName;
  late String potMac;
  late List<String> potConnection;
  late Set<String> potSensorData;
  @MapTo('owner_id')
  late String ownerId;
}
/*
---- User Schema -------
      | (Key, Map -> _id)
      |__ObjectID: _id
      |__bool: false (intitial)
      |__String?: username
      |__DateTime?: dateLastServiced
      |__List: plany_potlist
                  | (Key)
                  |__String?: pot_name
                  |__String?: pot_plantname
                  |__String?: pot_mac_address
                  |__Set: pot_senosorData
                                |__int?: humidity
                                |__int?: temperature
                                |__String?: soilMoisture
                                |__String?: lightIntensity
                                |__String?: waterTankLevel
                                |__String?: levelSensor
 */


// @RealmModel()
// class _PlantUserData{
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId id;
//   bool isComplete = false;
//   late String? username;
//   late String? pot_plantname;
//   late String? pot_mac_adrress;
//   late int? humidity = 0;
//   late int? temperature = 0;
//   late String? soilMoisture = '0';
//   late String? lightIntensity = '0';
//   late String? waterTankLevel = '0';
//   late String? levelSensor = '0';
//
// }



/*
class _Item {
  @MapTo('_id')
  @PrimaryKey()

  late ObjectId id;

  bool isComplete = false;

  late String summary;

  @MapTo('owner_id')

  late String ownerId;
}
//  */
//
// @RealmModel()
// class _PlantUser{
//   @PrimaryKey()
//   @MapTo('_id')
//   late ObjectId id;
//   late ObjectId _id;
//   bool isComplete = false;
//   late String? username;
//   late DateTime dateLastServiced;
//   late List<_Pot> plant_potList;
// }
// @RealmModel()
// class _Pot {
//   @PrimaryKey()
//   late String? pot_name;
//   late String? pot_plantname;
//   late String? pot_mac_adrress;
//   late Set<_PotSensorData> pot_sensorData;
// }
// @RealmModel()
// class _PotSensorData {
//   late int? humidity=0;
//   late int? temperature=0;
//   late String? soilMoisture;
//   late String? lightIntensity;
//   late String? waterTankLevel;
//   late String? levelSensor;
// }
