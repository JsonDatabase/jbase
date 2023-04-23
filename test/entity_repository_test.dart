import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

void main() {
  test('Create Entity', () {
    EntityRepository entityRepository = EntityRepository();
    String json = '{"name": "John", "age": 30, "over_18": true, "height": 1.8}';
    entityRepository.addEntity('Person', json);
    Entity? entity = entityRepository.getEntity('Person');
    expect(entity?.name, 'Person');
    expect(entity?.properties.length, 4);
    expect(entity?.properties[0].key, 'name');
    expect(entity?.properties[0].type, EntityPropertyType.string);
    expect(entity?.properties[1].key, 'age');
    expect(entity?.properties[1].type, EntityPropertyType.int);
    expect(entity?.properties[2].key, 'over_18');
    expect(entity?.properties[2].type, EntityPropertyType.bool);
    expect(entity?.properties[3].key, 'height');
    expect(entity?.properties[3].type, EntityPropertyType.double);
  });

  test('Create Entity with nested object', () {
    EntityRepository entityRepository = EntityRepository();
    String json =
        '{"name": "John", "age": 30, "over_18": true, "height": 1.8, "address": {"street": "Main Street", "number": 123}}';
    entityRepository.addEntity('Person', json);
    Entity? entity = entityRepository.getEntity('Person');
    expect(entity?.name, 'Person');
    expect(entity?.properties.length, 5);
    expect(entity?.properties[0].key, 'name');
    expect(entity?.properties[0].type, EntityPropertyType.string);
    expect(entity?.properties[1].key, 'age');
    expect(entity?.properties[1].type, EntityPropertyType.int);
    expect(entity?.properties[2].key, 'over_18');
    expect(entity?.properties[2].type, EntityPropertyType.bool);
    expect(entity?.properties[3].key, 'height');
    expect(entity?.properties[3].type, EntityPropertyType.double);
    expect(entity?.properties[4].key, 'address');
    expect(entity?.properties[4].type, EntityPropertyType.entity);
    expect(entity?.properties[4].value?.name, 'address');
    expect(entity?.properties[4].value?.properties.length, 2);
    expect(entity?.properties[4].value?.properties[0].key, 'street');
    expect(entity?.properties[4].value?.properties[0].type,
        EntityPropertyType.string);
    expect(entity?.properties[4].value?.properties[1].key, 'number');
    expect(entity?.properties[4].value?.properties[1].type,
        EntityPropertyType.int);
  });

  test('Create Entity with nested list', () {
    EntityRepository entityRepository = EntityRepository();
    String json =
        '{"name": "John", "age": 30, "over_18": true, "height": 1.8, "addresses": [{"street": "Main Street", "number": 123}, {"street": "Second Street", "number": 456}]}';
    entityRepository.addEntity('Person', json);
    Entity? entity = entityRepository.getEntity('Person');
    expect(entity?.name, 'Person');
    expect(entity?.properties.length, 5);
    expect(entity?.properties[0].key, 'name');
    expect(entity?.properties[0].type, EntityPropertyType.string);
    expect(entity?.properties[1].key, 'age');
    expect(entity?.properties[1].type, EntityPropertyType.int);
    expect(entity?.properties[2].key, 'over_18');
    expect(entity?.properties[2].type, EntityPropertyType.bool);
    expect(entity?.properties[3].key, 'height');
    expect(entity?.properties[3].type, EntityPropertyType.double);
    expect(entity?.properties[4].key, 'addresses');
    expect(entity?.properties[4].type, EntityPropertyType.list);
    expect(entity?.properties[4].value?.name, 'addresses');
    expect(entity?.properties[4].value?.properties.length, 2);
    expect(entity?.properties[4].value?.properties[0].key, 'street');
    expect(entity?.properties[4].value?.properties[0].type,
        EntityPropertyType.string);
    expect(entity?.properties[4].value?.properties[1].key, 'number');
    expect(entity?.properties[4].value?.properties[1].type,
        EntityPropertyType.int);
  });

  test('Create Entity with nested list of objects', () {
    EntityRepository entityRepository = EntityRepository();
    String json =
        '{"name": "John", "age": 30, "over_18": true, "height": 1.8, "addresses": [{"street": "Main Street", "number": 123}, {"street": "Second Street", "number": 456}], "friends": [{"name": "Peter", "age": 40}, {"name": "Mary", "age": 35}]}';
    entityRepository.addEntity('Person', json);
    Entity? entity = entityRepository.getEntity('Person');
    expect(entity?.name, 'Person');
    expect(entity?.properties.length, 6);
    expect(entity?.properties[0].key, 'name');
    expect(entity?.properties[0].type, EntityPropertyType.string);
    expect(entity?.properties[1].key, 'age');
    expect(entity?.properties[1].type, EntityPropertyType.int);
    expect(entity?.properties[2].key, 'over_18');
    expect(entity?.properties[2].type, EntityPropertyType.bool);
    expect(entity?.properties[3].key, 'height');
    expect(entity?.properties[3].type, EntityPropertyType.double);
    expect(entity?.properties[4].key, 'addresses');
    expect(entity?.properties[4].type, EntityPropertyType.list);
    expect(entity?.properties[4].value?.name, 'addresses');
    expect(entity?.properties[4].value?.properties.length, 2);
    expect(entity?.properties[4].value?.properties[0].key, 'street');
    expect(entity?.properties[4].value?.properties[0].type,
        EntityPropertyType.string);
    expect(entity?.properties[4].value?.properties[1].key, 'number');
    expect(entity?.properties[4].value?.properties[1].type,
        EntityPropertyType.int);
    expect(entity?.properties[5].key, 'friends');
    expect(entity?.properties[5].type, EntityPropertyType.list);
    expect(entity?.properties[5].value?.name, 'friends');
    expect(entity?.properties[5].value?.properties.length, 2);
    expect(entity?.properties[5].value?.properties[0].key, 'name');
    expect(entity?.properties[5].value?.properties[0].type,
        EntityPropertyType.string);
    expect(entity?.properties[5].value?.properties[1].key, 'age');
    expect(entity?.properties[5].value?.properties[1].type,
        EntityPropertyType.int);
  });

  test("Entity Repository To Map", () {
    EntityRepository entityRepository = EntityRepository();
    String json = '{"name": "John", "age": 30, "over_18": true, "height": 1.8}';
    entityRepository.addEntity('Person', json);
    Map<String, dynamic> map = entityRepository.toMap();
    expect(map, {
      "entities": [
        {
          "name": "Person",
          "properties": [
            {"key": "name", "type": 0, "value": null},
            {"key": "age", "type": 1, "value": null},
            {"key": "over_18", "type": 3, "value": null},
            {"key": "height", "type": 2, "value": null}
          ]
        }
      ]
    });
  });

  test("Entity Repository From Map", () {
    EntityRepository entityRepository = EntityRepository();
    String json = '{"name": "John", "age": 30, "over_18": true, "height": 1.8}';
    entityRepository.addEntity('Person', json);
    Map<String, dynamic> map = entityRepository.toMap();
    EntityRepository entityRepository2 = EntityRepository.fromMap(map);
    expect(entityRepository2.toMap(), map);
  });

  test("Entity To Map", () {
    Entity entity = Entity(name: 'Person');
    entity.addProperty(
        EntityProperty(key: 'name', type: EntityPropertyType.string));
    entity.addProperty(EntityProperty(
      key: 'age',
      type: EntityPropertyType.int,
    ));
    entity.addProperty(EntityProperty(
      key: 'over_18',
      type: EntityPropertyType.bool,
    ));

    Map<String, dynamic> map = entity.toMap();
    expect(map, {
      "name": "Person",
      "properties": [
        {"key": "name", "type": 0, "value": null},
        {"key": "age", "type": 1, "value": null},
        {"key": "over_18", "type": 3, "value": null}
      ]
    });
  });

  test("Entity From Map", () {
    Entity entity = Entity(name: 'Person');
    entity.addProperty(
        EntityProperty(key: 'name', type: EntityPropertyType.string));
    entity.addProperty(EntityProperty(
      key: 'age',
      type: EntityPropertyType.int,
    ));
    entity.addProperty(EntityProperty(
      key: 'over_18',
      type: EntityPropertyType.bool,
    ));

    Map<String, dynamic> map = entity.toMap();
    Entity entity2 = Entity.fromMap(map);
    expect(entity2.toMap(), map);
  });
}
