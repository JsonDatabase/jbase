import 'package:jbase_package/src/entity_repository/entity.dart';

enum EntityPropertyType { string, int, double, bool, entity }

class EntityProperty {
  String key;
  EntityPropertyType type;
  Entity? value;

  EntityProperty(this.key, {required this.type, this.value});

  bool get isEntity => type == EntityPropertyType.entity;

  @override
  String toString() {
    if (type == EntityPropertyType.entity) {
      return "Entity Type ${value.toString()}";
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
}
