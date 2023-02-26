import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/src/json_parser/json_parser.dart';
import 'package:jbase_package/src/json_parser/json_parser_result.dart';

void main() {
  test('Json Parser Result', () {
    String json = '{"name": "John", "age": 30, "over_18": true}';
    Map<String, dynamic> mappedJson = jsonDecode(json);
    JsonParserResult jsonParserResult = JsonParserResult(json, mappedJson);
    expect(jsonParserResult.json, json);
    expect(jsonParserResult.mappedJson['name'], 'John');
    expect(jsonParserResult.mappedJson['age'], 30);
    expect(jsonParserResult.mappedJson['over_18'], true);
    expect(jsonParserResult.numberOfKeys, 3);
  });
  
  test('Build Map From Json', () {
    String json = '{"name": "John", "age": 30, "over_18": true}';
    JsonParser jsonParser = JsonParser();
    JsonParserResult jsonParserResult = jsonParser.buildMapFromJson(json);
    expect(jsonParserResult.json, json);
    expect(jsonParserResult.mappedJson['name'], 'John');
    expect(jsonParserResult.mappedJson['age'], 30);
    expect(jsonParserResult.mappedJson['over_18'], true);
    expect(jsonParserResult.numberOfKeys, 3);
  });
}
