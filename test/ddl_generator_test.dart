import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/src/ddl_generator/ddl_generator.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';
import 'package:jbase_package/src/json_parser/json_parser.dart';
import 'package:jbase_package/src/json_parser/json_parser_result.dart';

void main() {
  test('DDL Generator', () {
    Entity entity = Entity();
    entity.name = 'person';
    entity.addProperty(EntityProperty('name', EntityPropertyType.string));
    entity.addProperty(EntityProperty('age', EntityPropertyType.int));
    entity.addProperty(EntityProperty('over_18', EntityPropertyType.bool));
    entity.addProperty(EntityProperty('height', EntityPropertyType.double));

    DDLGenerator ddlGenerator = DDLGenerator(entity);
    String ddl = ddlGenerator.generate();
    print(ddl);
  });
}
