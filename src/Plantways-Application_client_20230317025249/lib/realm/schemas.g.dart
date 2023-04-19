// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class PlantUserData extends _PlantUserData
    with RealmEntity, RealmObjectBase, RealmObject {
  PlantUserData(
    ObjectId id,
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
  }

  PlantUserData._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get humidity => RealmObjectBase.get<int>(this, 'humidity') as int?;
  @override
  set humidity(int? value) => RealmObjectBase.set(this, 'humidity', value);

  @override
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
    ]);
  }
}
