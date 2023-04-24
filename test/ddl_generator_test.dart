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
    String json =
        '{"cost": "25.00", "country_code_of_origin": "FR", "country_harmonized_system_codes": [{"harmonized_system_code": "1234561111","country_code": "CA"},{"harmonized_system_code": "1234562222","country_code": "US"}],"created_at": "2012-08-24T14:01:47-04:00","harmonized_system_code": 123456,"id": 450789469,"province_code_of_origin": "QC","sku": "IPOD2008PINK","tracked": true,"updated_at": "2012-08-24T14:01:47-04:00","requires_shipping": true}';
    Entity person = entityRepository.addEntity('Testing', json);
    MYSQLDatabaseManagementSystem dbms =
        MYSQLDatabaseManagementSystem(ControlPlaneSetting());
    String ddl = dbms.generateExecutableEntityDDL(entityRepository);
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
