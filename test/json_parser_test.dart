import 'package:flutter_test/flutter_test.dart';

import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/json_parser/json_parser.dart';

void main() {
  test('Build Map From Json', () {
    String json = '{"name": "John", "age": 30, "over_18": true}';
    JsonParser jsonParser = JsonParser();
    JsonParserResult jsonParserResult = jsonParser.buildMapFromJson(json);
    expect(jsonParserResult.json, json);
    expect(jsonParserResult.mappedJson['name'], 'John');
    expect(jsonParserResult.mappedJson['age'], 30);
    expect(jsonParserResult.mappedJson['over_18'], true);
  });
}
