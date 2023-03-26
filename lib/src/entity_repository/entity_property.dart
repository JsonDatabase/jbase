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
    if (value != null) {
      String nestedKey = value?.name as String;
      return 'EntityProperty{key: $key, value: $nestedKey}';
    } else {
      return 'EntityProperty{key: $key, type: $type}';
    }
  }
}
