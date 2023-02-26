import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

void main() {
  test('Create Entity', () {
    EntityRepository entityRepository = EntityRepository();
    String json = '{"name": "John", "age": 30, "over_18": true}';
    entityRepository.addEntity('Person', json);
    expect(entityRepository.entities.length, 1);
    expect(entityRepository.entities[0].name, 'Person');
    expect(entityRepository.entities[0].properties.length, 3);
    expect(entityRepository.entities[0].properties[0].key, "name");
    expect(entityRepository.entities[0].properties[0].type,
        EntityPropertyType.string);
    expect(entityRepository.entities[0].properties[1].key, "age");
    expect(entityRepository.entities[0].properties[1].type,
        EntityPropertyType.int);
    expect(entityRepository.entities[0].properties[2].key, "over_18");
    expect(entityRepository.entities[0].properties[2].type,
        EntityPropertyType.bool);
  });
}
