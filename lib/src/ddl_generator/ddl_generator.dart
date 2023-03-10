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
      case EntityPropertyType.entity:
        return '$type';
    }
  }

  String generate(Entity entity) {
    var foreignKeyRepository = [];

    var ddl = 'CREATE TABLE ${entity.name} (\n';
    ddl += '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n';
    entity.properties.forEach((element) {
      if (element.type == EntityPropertyType.entity) {
        var key = '${element.key.substring(0, 1)}id';
        var type = 'BIGINT UNSIGNED';
        var nullable = 'NOT NULL';
        ddl += '  $key $type $nullable,\n';
        foreignKeyRepository.add(
            'CONSTRAINT ${entity.name.toLowerCase()}_${element.value?.name.toLowerCase()}_id_fk FOREIGN KEY ($key) REFERENCES ${element.value?.name.toLowerCase()} (id);');
      } else {
        var key = element.key;
        var type = element.type;
        ddl += '  $key ${typeConversion(type)},\n';
      }
    });

    foreignKeyRepository.forEach((element) {
      ddl += '\n  $element\n';
    });

    ddl += ');\n';

    return ddl;
  }

  String generateStoredProcedures(Entity entity) {
    var ddl = '';
    return ddl;
  }
}
