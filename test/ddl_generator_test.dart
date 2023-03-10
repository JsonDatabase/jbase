import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/ddl_generator/ddl_generator.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';

void main() {
  test('DDL Generator - Default Settings', () {
    Entity entity = Entity();
    entity.name = 'person';
    entity.addProperty(EntityProperty('name', type: EntityPropertyType.string));
    entity.addProperty(EntityProperty('age', type: EntityPropertyType.int));
    entity
        .addProperty(EntityProperty('over_18', type: EntityPropertyType.bool));
    entity
        .addProperty(EntityProperty('height', type: EntityPropertyType.double));

    DDLGenerator ddlGenerator = DDLGenerator(ControlPlaneSetting());
    String ddl = ddlGenerator.generate(entity);
    expect(
        ddl,
        'CREATE TABLE person (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  name VARCHAR (250),\n'
        '  age INT,\n'
        '  over_18 SMALLINT,\n'
        '  height DOUBLE(10,2),\n'
        ');\n');
  });

  test("DDL Generation - No Primary Key Strategy", () {
    Entity entity = Entity();
    entity.name = 'person';
    entity.addProperty(EntityProperty('name', type: EntityPropertyType.string));
    entity.addProperty(EntityProperty('age', type: EntityPropertyType.int));
    entity
        .addProperty(EntityProperty('over_18', type: EntityPropertyType.bool));
    entity
        .addProperty(EntityProperty('height', type: EntityPropertyType.double));
    ControlPlaneSetting controlPlaneSetting = ControlPlaneSetting();
    controlPlaneSetting.primaryKeyStrategy = PrimaryKeyStrategy.none;

    DDLGenerator ddlGenerator = DDLGenerator(controlPlaneSetting);
    String ddl = ddlGenerator.generate(entity);
    expect(
        ddl,
        'CREATE TABLE person (\n'
        '  name VARCHAR (250),\n'
        '  age INT,\n'
        '  over_18 SMALLINT,\n'
        '  height DOUBLE(10,2),\n'
        ');\n');
  });
}
