// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class PlantUserData extends _PlantUserData
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  PlantUserData(
    ObjectId id, {
    bool isComplete = false,
    String? username,
    String? pot_plantname,
    String? pot_mac_adrress,
    int? humidity = 0,
    int? temperature = 0,
    String? soilMoisture = '0',
    String? lightIntensity = '0',
    String? waterTankLevel = '0',
    String? levelSensor = '0',
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<PlantUserData>({
        'isComplete': false,
        'humidity': 0,
        'temperature': 0,
        'soilMoisture': '0',
        'lightIntensity': '0',
        'waterTankLevel': '0',
        'levelSensor': '0',
      });
    }
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'isComplete', isComplete);
    RealmObjectBase.set(this, 'username', username);
    RealmObjectBase.set(this, 'pot_plantname', pot_plantname);
    RealmObjectBase.set(this, 'pot_mac_adrress', pot_mac_adrress);
    RealmObjectBase.set(this, 'humidity', humidity);
    RealmObjectBase.set(this, 'temperature', temperature);
    RealmObjectBase.set(this, 'soilMoisture', soilMoisture);
    RealmObjectBase.set(this, 'lightIntensity', lightIntensity);
    RealmObjectBase.set(this, 'waterTankLevel', waterTankLevel);
    RealmObjectBase.set(this, 'levelSensor', levelSensor);
  }

  PlantUserData._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  bool get isComplete => RealmObjectBase.get<bool>(this, 'isComplete') as bool;
  @override
  set isComplete(bool value) => RealmObjectBase.set(this, 'isComplete', value);

  @override
  String? get username =>
      RealmObjectBase.get<String>(this, 'username') as String?;
  @override
  set username(String? value) => RealmObjectBase.set(this, 'username', value);

  @override
  String? get pot_plantname =>
      RealmObjectBase.get<String>(this, 'pot_plantname') as String?;
  @override
  set pot_plantname(String? value) =>
      RealmObjectBase.set(this, 'pot_plantname', value);

  @override
  String? get pot_mac_adrress =>
      RealmObjectBase.get<String>(this, 'pot_mac_adrress') as String?;
  @override
  set pot_mac_adrress(String? value) =>
      RealmObjectBase.set(this, 'pot_mac_adrress', value);

  @override
  int? get humidity => RealmObjectBase.get<int>(this, 'humidity') as int?;
  @override
  set humidity(int? value) => RealmObjectBase.set(this, 'humidity', value);

  @override
  int? get temperature => RealmObjectBase.get<int>(this, 'temperature') as int?;
  @override
  set temperature(int? value) =>
      RealmObjectBase.set(this, 'temperature', value);

  @override
  String? get soilMoisture =>
      RealmObjectBase.get<String>(this, 'soilMoisture') as String?;
  @override
  set soilMoisture(String? value) =>
      RealmObjectBase.set(this, 'soilMoisture', value);

  @override
  String? get lightIntensity =>
      RealmObjectBase.get<String>(this, 'lightIntensity') as String?;
  @override
  set lightIntensity(String? value) =>
      RealmObjectBase.set(this, 'lightIntensity', value);

  @override
  String? get waterTankLevel =>
      RealmObjectBase.get<String>(this, 'waterTankLevel') as String?;
  @override
  set waterTankLevel(String? value) =>
      RealmObjectBase.set(this, 'waterTankLevel', value);

  @override
  String? get levelSensor =>
      RealmObjectBase.get<String>(this, 'levelSensor') as String?;
  @override
  set levelSensor(String? value) =>
      RealmObjectBase.set(this, 'levelSensor', value);

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
      SchemaProperty('isComplete', RealmPropertyType.bool),
      SchemaProperty('username', RealmPropertyType.string, optional: true),
      SchemaProperty('pot_plantname', RealmPropertyType.string, optional: true),
      SchemaProperty('pot_mac_adrress', RealmPropertyType.string,
          optional: true),
      SchemaProperty('humidity', RealmPropertyType.int, optional: true),
      SchemaProperty('temperature', RealmPropertyType.int, optional: true),
      SchemaProperty('soilMoisture', RealmPropertyType.string, optional: true),
      SchemaProperty('lightIntensity', RealmPropertyType.string,
          optional: true),
      SchemaProperty('waterTankLevel', RealmPropertyType.string,
          optional: true),
      SchemaProperty('levelSensor', RealmPropertyType.string, optional: true),
    ]);
  }
}
