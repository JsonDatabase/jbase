import 'dart:convert';
import 'package:jbase_package/src/json_parser/json_parser_result.dart';

class JsonParser {
  JsonParserResult buildMapFromJson(String json) {
    Map<String, dynamic> mappedJson = jsonDecode(json);
    return JsonParserResult(json, mappedJson);
  }
}
