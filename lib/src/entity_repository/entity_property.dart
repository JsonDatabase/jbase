import 'package:jbase_package/src/entity_repository/entity.dart';

enum EntityPropertyType { string, int, double, bool, entity, list }

class EntityProperty {
  String key;
  EntityPropertyType type;
  Entity? value;

  EntityProperty({required this.key, required this.type, this.value});

  factory EntityProperty.fromMap(Map<String, dynamic> map) {
    return EntityProperty(
      key: map['key'],
      type: EntityPropertyType.values[map['type']],
      value: map['value'] != null ? Entity.fromMap(map['value']) : null,
    );
  }

  bool get isEntity => type == EntityPropertyType.entity;

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
      'type': type,
      'value': value?.toMap(),
    };
  }
}
