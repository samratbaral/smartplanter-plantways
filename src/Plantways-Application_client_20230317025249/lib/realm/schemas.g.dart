// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class PlantUserData extends _PlantUserData
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  PlantUserData(
    ObjectId id,
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
  @override
  set potConnection(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmSet<String> get potSensorData =>
      RealmObjectBase.get<String>(this, 'potSensorData') as RealmSet<String>;
  @override
  set potSensorData(covariant RealmSet<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get ownerId => RealmObjectBase.get<String>(this, 'owner_id') as String;
  @override
  set ownerId(String value) => RealmObjectBase.set(this, 'owner_id', value);

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
      SchemaProperty('plantName', RealmPropertyType.string),
      SchemaProperty('potName', RealmPropertyType.string),
      SchemaProperty('potMac', RealmPropertyType.string),
      SchemaProperty('potConnection', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('potSensorData', RealmPropertyType.string,
          collectionType: RealmCollectionType.set),
      SchemaProperty('ownerId', RealmPropertyType.string, mapTo: 'owner_id'),
    ]);
  }
}
