import 'dart:convert';

class JsonParser {
  JsonParserResult buildMapFromJson(String json) {
    Map<String, dynamic> mappedJson = jsonDecode(json);
    return JsonParserResult(json, mappedJson);
  }
}

class JsonParserResult {
  final String json;
  final Map<String, dynamic> mappedJson;

  JsonParserResult(this.json, this.mappedJson);
}
