import 'package:jbase_package/src/entity_repository/entity_property.dart';

class Entity implements Comparable<Entity> {
  List<EntityProperty> properties = [];
  String name;

  Entity({
    required this.name,
    this.properties = const [],
  });

  factory Entity.fromMap(Map<String, dynamic> map) {
    return Entity(
      name: map['name'],
      properties: List<EntityProperty>.from(
          map['properties']?.map((x) => EntityProperty.fromMap(x))),
    );
  }

  int get propertyCount => properties.length;

  int get entityPropertyCount {
    int count = 0;
    for (EntityProperty property in properties) {
      if (property.type == EntityPropertyType.entity) {
        count++;
      }
    }
    return count;
  }

  void addProperty(EntityProperty property) {
    properties = [...properties, property];
  }

  @override
  String toString() {
    return name;
  }

  @override
  int compareTo(Entity other) {
    return name.compareTo(other.name);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    bool hasSameProperties = true;
    for (int i = 0; i < properties.length; i++) {
      if (!(other as Entity).properties.contains(properties[i])) {
        hasSameProperties = false;
        break;
      }
    }
    return hasSameProperties;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'properties': properties.map((property) => property.toMap()).toList(),
    };
  }
}
