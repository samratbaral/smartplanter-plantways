// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class PlantUserData extends _PlantUserData
    with RealmEntity, RealmObjectBase, RealmObject {
  PlantUserData(
    ObjectId id,
<<<<<<< HEAD
    String plantName,
    String potName,
    String potMac,
    String ownerId, {
    bool isComplete = false,
    Iterable<String> potConnection = const [],
    Set<String> potSensorData = const {},
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<PlantUserData>({
        'isComplete': false,
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'isComplete', isComplete);
    RealmObjectBase.set(this, 'plantName', plantName);
    RealmObjectBase.set(this, 'potName', potName);
    RealmObjectBase.set(this, 'potMac', potMac);
    RealmObjectBase.set(this, 'owner_id', ownerId);
    RealmObjectBase.set<RealmList<String>>(
        this, 'potConnection', RealmList<String>(potConnection));
    RealmObjectBase.set<RealmSet<String>>(
        this, 'potSensorData', RealmSet<String>(potSensorData));
=======
    bool isComplete, {
    int? humidity,
    String? levelSensor,
    String? lightIntensity,
    String? potMacAdrress,
    String? potPlantname,
    String? soilMoisture,
    int? temperature,
    String? username,
    String? waterTankLevel,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'humidity', humidity);
    RealmObjectBase.set(this, 'isComplete', isComplete);
    RealmObjectBase.set(this, 'levelSensor', levelSensor);
    RealmObjectBase.set(this, 'lightIntensity', lightIntensity);
    RealmObjectBase.set(this, 'pot_mac_adrress', potMacAdrress);
    RealmObjectBase.set(this, 'pot_plantname', potPlantname);
    RealmObjectBase.set(this, 'soilMoisture', soilMoisture);
    RealmObjectBase.set(this, 'temperature', temperature);
    RealmObjectBase.set(this, 'username', username);
    RealmObjectBase.set(this, 'waterTankLevel', waterTankLevel);
>>>>>>> 26750efd1f1ff59228096e8e0b921e53141aeedf
  }

  PlantUserData._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
<<<<<<< HEAD
  bool get isComplete => RealmObjectBase.get<bool>(this, 'isComplete') as bool;
  @override
  set isComplete(bool value) => RealmObjectBase.set(this, 'isComplete', value);

  @override
  String get plantName =>
      RealmObjectBase.get<String>(this, 'plantName') as String;
  @override
  set plantName(String value) => RealmObjectBase.set(this, 'plantName', value);

  @override
  String get potName => RealmObjectBase.get<String>(this, 'potName') as String;
  @override
  set potName(String value) => RealmObjectBase.set(this, 'potName', value);

  @override
  String get potMac => RealmObjectBase.get<String>(this, 'potMac') as String;
  @override
  set potMac(String value) => RealmObjectBase.set(this, 'potMac', value);

  @override
  RealmList<String> get potConnection =>
      RealmObjectBase.get<String>(this, 'potConnection') as RealmList<String>;
=======
  int? get humidity => RealmObjectBase.get<int>(this, 'humidity') as int?;
>>>>>>> 26750efd1f1ff59228096e8e0b921e53141aeedf
  @override
  set potConnection(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
<<<<<<< HEAD
  RealmSet<String> get potSensorData =>
      RealmObjectBase.get<String>(this, 'potSensorData') as RealmSet<String>;
  @override
  set potSensorData(covariant RealmSet<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);
=======
  bool get isComplete => RealmObjectBase.get<bool>(this, 'isComplete') as bool;
  @override
  set isComplete(bool value) => RealmObjectBase.set(this, 'isComplete', value);

  @override
  String? get levelSensor =>
      RealmObjectBase.get<String>(this, 'levelSensor') as String?;
  @override
  set levelSensor(String? value) =>
      RealmObjectBase.set(this, 'levelSensor', value);

  @override
  String? get lightIntensity =>
      RealmObjectBase.get<String>(this, 'lightIntensity') as String?;
  @override
  set lightIntensity(String? value) =>
      RealmObjectBase.set(this, 'lightIntensity', value);

  @override
  String? get potMacAdrress =>
      RealmObjectBase.get<String>(this, 'pot_mac_adrress') as String?;
  @override
  set potMacAdrress(String? value) =>
      RealmObjectBase.set(this, 'pot_mac_adrress', value);

  @override
  String? get potPlantname =>
      RealmObjectBase.get<String>(this, 'pot_plantname') as String?;
  @override
  set potPlantname(String? value) =>
      RealmObjectBase.set(this, 'pot_plantname', value);

  @override
  String? get soilMoisture =>
      RealmObjectBase.get<String>(this, 'soilMoisture') as String?;
  @override
  set soilMoisture(String? value) =>
      RealmObjectBase.set(this, 'soilMoisture', value);

  @override
  int? get temperature => RealmObjectBase.get<int>(this, 'temperature') as int?;
  @override
  set temperature(int? value) =>
      RealmObjectBase.set(this, 'temperature', value);

  @override
  String? get username =>
      RealmObjectBase.get<String>(this, 'username') as String?;
  @override
  set username(String? value) => RealmObjectBase.set(this, 'username', value);

  @override
  String? get waterTankLevel =>
      RealmObjectBase.get<String>(this, 'waterTankLevel') as String?;
  @override
  set waterTankLevel(String? value) =>
      RealmObjectBase.set(this, 'waterTankLevel', value);
>>>>>>> 26750efd1f1ff59228096e8e0b921e53141aeedf

  @override
  Stream<RealmObjectChanges<PlantUserData>> get changes =>
      RealmObjectBase.getChanges<PlantUserData>(this);

  @override
  PlantUserData freeze() => RealmObjectBase.freezeObject<PlantUserData>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(PlantUserData._);
    return const SchemaObject(
        ObjectType.realmObject, PlantUserData, 'PlantUserData', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
<<<<<<< HEAD
      SchemaProperty('isComplete', RealmPropertyType.bool),
      SchemaProperty('plantName', RealmPropertyType.string),
      SchemaProperty('potName', RealmPropertyType.string),
      SchemaProperty('potMac', RealmPropertyType.string),
      SchemaProperty('potConnection', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('potSensorData', RealmPropertyType.string,
          collectionType: RealmCollectionType.set),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
=======
      SchemaProperty('humidity', RealmPropertyType.int, optional: true),
      SchemaProperty('isComplete', RealmPropertyType.bool),
      SchemaProperty('levelSensor', RealmPropertyType.string, optional: true),
      SchemaProperty('lightIntensity', RealmPropertyType.string,
          optional: true),
      SchemaProperty('potMacAdrress', RealmPropertyType.string,
          mapTo: 'pot_mac_adrress', optional: true),
      SchemaProperty('potPlantname', RealmPropertyType.string,
          mapTo: 'pot_plantname', optional: true),
      SchemaProperty('soilMoisture', RealmPropertyType.string, optional: true),
      SchemaProperty('temperature', RealmPropertyType.int, optional: true),
      SchemaProperty('username', RealmPropertyType.string, optional: true),
      SchemaProperty('waterTankLevel', RealmPropertyType.string,
          optional: true),
>>>>>>> 26750efd1f1ff59228096e8e0b921e53141aeedf
    ]);
  }
}
