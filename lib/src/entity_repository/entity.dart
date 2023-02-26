import 'package:jbase_package/src/entity_repository/entity_property/entity_property.dart';

class Entity {
  String name;
  List<EntityProperty> properties;

  Entity(this.name, this.properties);

  @override
  String toString() {
    return 'Entity{name: $name, properties: $properties}';
  }
}
