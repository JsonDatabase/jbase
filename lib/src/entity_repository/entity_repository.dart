import 'dart:convert';

import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';
import 'package:jbase_package/src/json_parser/json_parser.dart';
import 'package:jbase_package/src/json_parser/json_parser_result.dart';

class EntityRepository {
  final JsonParser _jsonParser = JsonParser();
  final List<Entity> _entities = [];

  Entity addEntity(String name, String json) {
    Entity? existingEntity = matchingEntity(json);
    if (existingEntity != null) {
      return existingEntity;
    }
    Entity entity = Entity();
    entity.name = name;
    JsonParserResult jsonParserResult = _jsonParser.buildMapFromJson(json);
    jsonParserResult.mappedJson.forEach((key, value) {
      EntityPropertyType entityPropertyType = EntityPropertyType.string;
      Entity? entityPropertyValue;
      if (value is int) {
        entityPropertyType = EntityPropertyType.int;
      } else if (value is double) {
        entityPropertyType = EntityPropertyType.double;
      } else if (value is bool) {
        entityPropertyType = EntityPropertyType.bool;
      } else if (value is Map<String, dynamic>) {
        entityPropertyValue = addEntity(key, jsonEncode(value));
        entityPropertyType = EntityPropertyType.entity;
      }
      EntityProperty entityProperty = EntityProperty(key,
          type: entityPropertyType, value: entityPropertyValue);
      entity.properties.add(entityProperty);
    });
    _entities.add(entity);
    return entity;
  }

  void removeEntity(String name) {
    _entities.removeWhere((entity) => entity.name == name);
  }

  get entities => _entities;

  Entity? matchingEntity(String json) {
    Entity? matchingEntity;
    JsonParserResult jsonParserResult = _jsonParser.buildMapFromJson(json);
    _entities.forEach((entity) {
      for (int i = 0; i < entity.properties.length; i++) {
        matchingEntity = entity;

        if (!jsonParserResult.mappedJson
            .containsKey(entity.properties[i].key)) {
          matchingEntity = null;
        }
      }
    });
    return matchingEntity;
  }
}
