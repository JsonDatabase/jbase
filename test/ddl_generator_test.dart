import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/ddl_generator/dbms/mysql_database_management_system.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

void main() {
  test('DDL Generator - Default Settings', () {
    ControlPlaneSetting controlPlaneSetting = ControlPlaneSetting();
    ControlPlane controlPlane = ControlPlane(controlPlaneSetting);
    EntityRepository entityRepository = EntityRepository(controlPlane);
    String json = '{"name": "John", "age": 30, "over_18": true, "height": 1.8}';
    Entity person = entityRepository.addEntity('Person', json);
    MYSQLDatabaseManagementSystem dbms =
        MYSQLDatabaseManagementSystem(ControlPlaneSetting());
    String ddl = dbms.generateEntityStoredProcedures(person);
    print(ddl);
    // expect(
    //     ddl,
    //     'CREATE TABLE person (\n'
    //     '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
    //     '  name VARCHAR (250),\n'
    //     '  age INT,\n'
    //     '  over_18 SMALLINT,\n'
    //     '  height DOUBLE(10,2),\n'
    //     ');\n');
  });

  // test("DDL Generation - No Primary Key Strategy", () {
  //   Entity entity = Entity();
  //   entity.name = 'person';
  //   entity.addProperty(EntityProperty('name', type: EntityPropertyType.string));
  //   entity.addProperty(EntityProperty('age', type: EntityPropertyType.int));
  //   entity
  //       .addProperty(EntityProperty('over_18', type: EntityPropertyType.bool));
  //   entity
  //       .addProperty(EntityProperty('height', type: EntityPropertyType.double));
  //   ControlPlaneSetting controlPlaneSetting = ControlPlaneSetting();
  //   controlPlaneSetting.primaryKeyStrategy = PrimaryKeyStrategy.none;

  //   DDLGenerator ddlGenerator = DDLGenerator(controlPlaneSetting);
  //   String ddl = ddlGenerator.generate(entity);
  //   expect(
  //       ddl,
  //       'CREATE TABLE person (\n'
  //       '  name VARCHAR (250),\n'
  //       '  age INT,\n'
  //       '  over_18 SMALLINT,\n'
  //       '  height DOUBLE(10,2),\n'
  //       ');\n');
  // });
}
