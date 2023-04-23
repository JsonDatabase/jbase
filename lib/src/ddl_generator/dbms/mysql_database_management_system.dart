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
    String deleteSP =
        'CREATE PROCEDURE ${entity.name}Delete(${entity.name.substring(0, 2).toLowerCase()}Id bigint unsigned) \nBEGIN \n\n DELETE FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;\n\nEND';
    return deleteSP;
  }

  @override
  String generateEntityGetAllStoredProcedure(Entity entity) {
    String body =
        'CREATE PROCEDURE ${entity.name}GetAll() \nBEGIN \n\n SELECT JSON_ARRAYAGG(JSON_OBJECT(\n';
    entity.properties.forEach((property) {
      body += "   '${property.key}', ${property.key},\n";
    });
    body += '   ))\n FROM ${entity.name};\n\nEND';
    return body;
  }

  @override
  String generateEntityGetByIdStoredProcedure(Entity entity) {
    String body =
        'CREATE PROCEDURE ${entity.name}GetById(${entity.name.substring(0, 2).toLowerCase()}Id bigint unsigned) \nBEGIN\n\n';
    body += 'SELECT JSON_OBJECT(\n';
    entity.properties.forEach((property) {
      if (property.type == EntityPropertyType.entity) {
        body += generateInnerSelect(property.value as Entity);
      } else {
        body += byIdBody(property);
      }
    });
    body += byIdFooter(entity);
    body += '\n\nEND';
    return body;
  }

  @override
  String generateEntityInsertStoredProcedure(Entity entity) {
    String ddl =
        'CREATE PROCEDURE ${entity.name}Create(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n';
    for (EntityProperty property in entity.properties) {
      ddl +=
          ' SET @var${property.key.toUpperCase()} = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.${property.key.toLowerCase()}\');\n';
    }
    ddl += '\n INSERT INTO ${entity.name} (\n';
    for (int i = 0; i < entity.properties.length; i++) {
      EntityProperty property = entity.properties[i];
      bool isLastProperty = i == entity.properties.length - 1;
      ddl += '   ${property.key}${!isLastProperty ? ',' : ''}\n';
    }
    ddl += '\n ) VALUES (\n';
    for (int i = 0; i < entity.properties.length; i++) {
      EntityProperty property = entity.properties[i];
      bool isLastProperty = i == entity.properties.length - 1;
      ddl +=
          '   JSON_UNQUOTE(@var${property.key.toUpperCase()})${!isLastProperty ? ',' : ''}\n';
    }
    ddl += ' );\n\nEND';
    return ddl;
  }

  @override
  String generateEntityUpdateStoredProcedure(Entity entity) {
    String ddl =
        'CREATE PROCEDURE ${entity.name}Update(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n';
    ddl +=
        ' SET @${entity.name.substring(0, 2).toLowerCase()}Id = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.id\');\n';
    for (EntityProperty property in entity.properties) {
      ddl +=
          ' SET @var${property.key.toUpperCase()} = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.${property.key.toLowerCase()}\');\n';
    }
    ddl += '\n UPDATE ${entity.name} SET\n';
    for (int i = 0; i < entity.properties.length; i++) {
      EntityProperty property = entity.properties[i];
      bool isLastProperty = i == entity.properties.length - 1;
      ddl +=
          '   ${property.key} = JSON_UNQUOTE(@var${property.key.toUpperCase()})${!isLastProperty ? ',\n' : ''}';
    }
    ddl += '\n WHERE id = @${entity.name.substring(0, 2).toLowerCase()}Id;';
    ddl += '\n\nEND';
    return ddl;
  }

  @override
  String generateEntityStoredProcedures(Entity entity) {
    String ddl = '';
    ddl += generateEntityInsertStoredProcedure(entity);
    ddl += '\n\n';
    ddl += generateEntityUpdateStoredProcedure(entity);
    ddl += '\n\n';
    ddl += generateEntityDeleteStoredProcedure(entity);
    ddl += '\n\n';
    ddl += generateEntityGetByIdStoredProcedure(entity);
    ddl += '\n\n';
    ddl += generateEntityGetAllStoredProcedure(entity);
    return ddl;
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

String generateInnerSelect(Entity entity) {
  String returnString = '\'${entity.name}\', (';
  returnString += selectJson();
  entity.properties.forEach((property) {
    returnString += byIdBody(property);
    if (property.type == EntityPropertyType.entity) {}
  });
  returnString += byIdFooter(entity);
  return returnString;
}

String byIdFooter(Entity entity) {
  return '   )\n FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;';
}

String byIdBody(EntityProperty property) {
  return "   '${property.key}', ${property.key},\n";
}

String selectJson() {
  return 'SELECT JSON_OBJECT(\n';
}
