class JsonParserResult {
  final String json;
  final Map<String, dynamic> mappedJson;

  JsonParserResult(this.json, this.mappedJson);

  int get numberOfKeys => mappedJson.keys.length;
}
