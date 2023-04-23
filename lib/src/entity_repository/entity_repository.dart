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
    Entity entity = Entity(name: name);
    JsonParserResult jsonParserResult = _jsonParser.buildMapFromJson(json);
    for (int i = 0; i < jsonParserResult.mappedJson.length; i++) {
      EntityPropertyType entityPropertyType = EntityPropertyType.string;
      Entity? entityPropertyValue;
      String key = jsonParserResult.mappedJson.keys.elementAt(i);
      dynamic value = jsonParserResult.mappedJson.values.elementAt(i);
      if (value is int) {
        entityPropertyType = EntityPropertyType.int;
      } else if (value is double) {
        entityPropertyType = EntityPropertyType.double;
      } else if (value is bool) {
        entityPropertyType = EntityPropertyType.bool;
      } else if (value is String) {
        entityPropertyType = EntityPropertyType.string;
      } else if (value is Map<String, dynamic>) {
        entityPropertyValue = addEntity(key, jsonEncode(value));
        entityPropertyType = EntityPropertyType.entity;
      } else if (value is List<dynamic> && value.isNotEmpty) {
        dynamic firstValue = value.first;
        entityPropertyValue = addEntity(key, jsonEncode(firstValue));
        entityPropertyType = EntityPropertyType.list;
      } else {
        continue;
      }
      entity.addProperty(EntityProperty(
          key: key, type: entityPropertyType, value: entityPropertyValue));
    }
    _entities.add(entity);
    return entity;
  }

  void removeEntity(String name) {
    _entities.removeWhere((entity) => entity.name == name);
  }

  List<Entity> get entities => _entities;

  Entity? getEntity(String name) {
    List<Entity> matchingEntities =
        _entities.where((entity) => entity.name == name).toList();
    if (matchingEntities.isNotEmpty) {
      return matchingEntities.first;
    }
    return null;
  }

  Entity? matchingEntity(String json) {
    Entity? matchingEntity;
    JsonParserResult jsonParserResult = _jsonParser.buildMapFromJson(json);
    for (Entity entity in _entities) {
      for (int i = 0; i < entity.properties.length; i++) {
        matchingEntity = entity;

        if (!jsonParserResult.mappedJson
            .containsKey(entity.properties[i].key)) {
          matchingEntity = null;
        }
      }
    }
    return matchingEntity;
  }
}
