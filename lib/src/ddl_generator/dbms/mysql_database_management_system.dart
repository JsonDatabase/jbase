import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/ddl_generator/dbms/database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/utils/repository.dart';

class MYSQLDatabaseManagementSystem extends DatabaseManagementSystem {
  MYSQLDatabaseManagementSystem(super.controlPlaneSetting);

  @override
  String generateEntityDDL(Entity entity) {
    String ddl = 'CREATE TABLE ${entity.name} (\n';
    for (int i = 0; i < entity.properties.length; i++) {
      EntityProperty property = entity.properties[i];
      bool isLastProperty = i == entity.properties.length - 1;
      if (property.type == EntityPropertyType.entity) {
        ddl +=
            '  ${property.key.substring(0, 1).toLowerCase()}id BIGINT UNSIGNED NOT NULL,\n';
      } else {
        ddl +=
            '  ${property.key.toLowerCase()} ${mySQLTypeConversion(property.type)}${!isLastProperty ? ',' : ''}\n';
      }
    }
    for (EntityProperty property in entity.properties) {
      if (property.type == EntityPropertyType.entity) {
        ddl +=
            '  CONSTRAINT ${property.key.toLowerCase()}_${entity.name.toLowerCase()}_${property.value?.name.toLowerCase()}_id_fk FOREIGN KEY (${property.key.substring(0, 1).toLowerCase()}id) REFERENCES ${property.value?.name.toLowerCase()} (id); \n';
      }
    }
    ddl += ');\n\n';
    return ddl;
  }

  @override
  String generateEntityDeleteStoredProcedure(Entity entity) {
    // TODO: implement generateEntityDeleteStoredProcedure
    throw UnimplementedError();
  }

  @override
  String generateEntityGetAllStoredProcedure(Entity entity) {
    // TODO: implement generateEntityGetAllStoredProcedure
    throw UnimplementedError();
  }

  @override
  String generateEntityGetByIdStoredProcedure(Entity entity) {
    // TODO: implement generateEntityGetByIdStoredProcedure
    throw UnimplementedError();
  }

  @override
  String generateEntityInsertStoredProcedure(Entity entity) {
    // TODO: implement generateEntityInsertStoredProcedure
    throw UnimplementedError();
  }

  @override
  String generateEntityStoredProcedures(Entity entity) {
    // TODO: implement generateEntityStoredProcedures
    throw UnimplementedError();
  }

  @override
  String generateEntityUpdateStoredProcedure(Entity entity) {
    // TODO: implement generateEntityUpdateStoredProcedure
    throw UnimplementedError();
  }

  @override
  List<String> columnDataTypes() {
    return [
      'BIT',
      'BOOL',
      'BOOLEAN',
      'TINYINT',
      'SMALLINT',
      'MEDIUMINT',
      'INT',
      'INTEGER',
      'BIGINT',
      'FLOAT',
      'DOUBLE',
      'DECIMAL',
      'NUMERIC',
      'DATE',
      'TIME',
      'YEAR',
      'DATETIME',
      'TIMESTAMP',
      'CHAR',
      'VARCHAR',
      'BINARY',
      'VARBINARY',
      'TINYBLOB',
      'BLOB',
      'MEDIUMBLOB',
      'LONGBLOB',
      'TINYTEXT',
      'TEXT',
      'MEDIUMTEXT',
      'LONGTEXT',
      'ENUM',
      'SET'
    ];
  }

  @override
  String entityPropertyTypeToColumnDataType(EntityPropertyType type) {
    switch (type) {
      case EntityPropertyType.bool:
        return 'BIT';
      case EntityPropertyType.int:
        return 'INT';
      case EntityPropertyType.double:
        return 'DOUBLE';
      case EntityPropertyType.string:
        return 'TEXT';
      case EntityPropertyType.entity:
        return 'Foreign Key Reference (Single)';
      case EntityPropertyType.list:
        return 'Foreign Key Reference (Multiple)';
      default:
        return '';
    }
  }
}
