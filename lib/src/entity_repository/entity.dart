import 'package:jbase_package/src/entity_repository/entity_property.dart';

class Entity {
  String name = '';
  final List<EntityProperty> _properties = [];

  void addProperty(EntityProperty entityProperty) {
    _properties.add(entityProperty);
  }

  get properties => _properties;

  @override
  String toString() {
    return 'Entity{name: $name, properties: $properties}';
  }
}
