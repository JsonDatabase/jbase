import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';

class DDLGenerator {
  final DatabaseType databaseType;
  DDLGenerator(this.databaseType);

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

  String generate(Entity entity) {
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
