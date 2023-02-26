import 'package:jbase_package/src/entity_repository/entity_property.dart';

import '../entity_repository/entity.dart';

class DDLGenerator {
  Entity entity;

  DDLGenerator(this.entity);

  String typeConversion(EntityPropertyType type) {
    switch (type) {
      case EntityPropertyType.string:
        return 'VARCHAR (250)';
      case EntityPropertyType.int:
        return 'INT';
      case EntityPropertyType.double:
        return 'DOUBLE(10,2)';
      case EntityPropertyType.bool:
        return 'SMALLINT';
    }
  }

  String generate() {
    var ddl = 'CREATE TABLE ${entity.name} (\n';
    entity.properties.forEach((element) {
      var key = element.key;
      var type = element.type;
      ddl += '  $key ${typeConversion(type)},\n';
    });

    ddl += ');';

    return ddl;
  }
}
