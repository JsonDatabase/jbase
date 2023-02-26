enum EntityPropertyType { string, int, double, bool }

class EntityProperty {
  String key;
  EntityPropertyType type;

  EntityProperty(this.key, this.type);

  @override
  String toString() {
    return 'EntityProperty{key: $key, type: $type}';
  }
}