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
        '{  "body_html": "Its the small iPod with a big idea: Video.",  "created_at": "2012-02-15T15:12:21-05:00",  "handle": "ipod-nano",  "id": 632910392,  "images": [    {      "id": 850703190,      "product_id": 632910392,      "position": 1,      "created_at": "2018-01-08T12:34:47-05:00",      "updated_at": "2018-01-08T12:34:47-05:00",      "width": 110,      "height": 140,      "src": "http://example.com/burton.jpg",      "variant_ids": [        {}      ]    }  ],  "options": {    "id": 594680422,    "product_id": 632910392,    "name": "Color",    "position": 1,    "values": [      "Pink",      "Red",      "Green",      "Black"    ]  },  "product_type": "Cult Products",  "published_at": "2007-12-31T19:00:00-05:00",  "published_scope": "global",  "status": "active",  "tags": "Emotive, Flash Memory, MP3, Music",  "template_suffix": "special",  "title": "IPod Nano - 8GB",  "updated_at": "2012-08-24T14:01:47-04:00",  "variants": [    {      "barcode": "1234_pink",      "compare_at_price": null,      "created_at": "2012-08-24T14:01:47-04:00",      "fulfillment_service": "manual",      "grams": 567,      "weight": 0.2,      "weight_unit": "kg",      "id": 808950810,      "inventory_item_id": 341629,      "inventory_management": "shopify",      "inventory_policy": "continue",      "inventory_quantity": 10,      "option1": "Pink",      "position": 1,      "price": 199.99,      "product_id": 632910392,      "requires_shipping": true,      "sku": "IPOD2008PINK",      "taxable": true,      "title": "Pink",      "updated_at": "2012-08-24T14:01:47-04:00"    }  ],  "vendor": "Apple"}';
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
