import 'package:jbase_package/src/entity_repository/entity.dart';

enum EntityPropertyType { string, int, double, bool, entity, list, foreignKey }

class EntityProperty {
  final String key;
  final EntityPropertyType type;
  Entity? value;
  String databaseManagementSystemColumnType = "VARCHAR";
  String? defaultValue;
  bool isPrimaryKey = false;

  EntityProperty({
    required this.key,
    required this.type,
    this.value,
    this.databaseManagementSystemColumnType = "VARCHAR",
    this.defaultValue,
    this.isPrimaryKey = false,
  });

  factory EntityProperty.fromMap(Map<String, dynamic> map) {
    return EntityProperty(
      key: map['key'],
      type: EntityPropertyType.values[map['type']],
      value: map['value'] != null ? Entity.fromMap(map['value']) : null,
      databaseManagementSystemColumnType: map['dbType'],
      defaultValue: map['defaultValue'],
      isPrimaryKey: map['isPrimaryKey'] ?? false,
    );
  }

  void addValue (Entity entity) {
    value = entity;
  }

  bool get isEntity => type == EntityPropertyType.entity && value != null;

  bool get isList => type == EntityPropertyType.list && value != null;

  @override
  String toString() {
    if (type == EntityPropertyType.entity) {
      return "Entity Type ${value.toString()}";
    } else if (type == EntityPropertyType.list) {
      return "List Type ${value.toString()}";
    } else if (type == EntityPropertyType.string) {
      return "String";
    } else if (type == EntityPropertyType.int) {
      return "Int";
    } else if (type == EntityPropertyType.double) {
      return "Double";
    } else if (type == EntityPropertyType.bool) {
      return "Bool";
    } else {
      return "Unknown";
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'type': type.index,
      'value': value?.toMap(),
      'dbType': databaseManagementSystemColumnType,
      'defaultValue': defaultValue,
      'isPrimaryKey': isPrimaryKey,
    };
  }
}
