import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/ddl_generator/dbms/database_management_system.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

class MYSQLDatabaseManagementSystem extends DatabaseManagementSystem {
  MYSQLDatabaseManagementSystem(ControlPlaneSetting controlPlaneSetting)
      : super(controlPlaneSetting);

  @override
  String generateExecutableEntityDDL(EntityRepository entityRepository) {
    String ddl = '';
    for (Entity entity in entityRepository.entities) {
      ddl += generateEntityDDL(entity);
    }
    for (Entity entity in entityRepository.entities) {
      ddl += generateEntityStoredProcedures(entity);
    }
    return ddl;
  }

  @override
  String generateEntityDDL(Entity entity) {
    bool primaryKeys = false;
    String ddl = 'CREATE TABLE ${entity.name} (\n';
    ddl += _generatePrimaryKey();
    List<EntityProperty> tableProperties = [...entity.properties];
    tableProperties
        .removeWhere((property) => property.type == EntityPropertyType.list);
    bool hasForeignKey = false;
    for (int i = 0; i < tableProperties.length; i++) {
      EntityProperty property = tableProperties[i];
      bool isLastProperty = i == tableProperties.length - 1;
      if (property.type == EntityPropertyType.entity) {
        hasForeignKey = true;
        ddl +=
            '  ${property.key.substring(0, 1).toLowerCase()}id BIGINT UNSIGNED NOT NULL,\n';
      } else if (property.type == EntityPropertyType.list) {
        continue;
      } else if (property.type == EntityPropertyType.foreignKey) {
        hasForeignKey = true;
        ddl +=
            '  ${property.key.substring(0, 1).toLowerCase()}id BIGINT UNSIGNED NOT NULL,\n';
      } else {
        if (property.key == 'id' && property.key.length == 2) {
          ddl += '';
        } else {
          ddl +=
              '  ${property.key.toLowerCase()} ${entityPropertyTypeToColumnDataType(property.type)}${!isLastProperty || hasForeignKey ? ',' : ''}\n';
        }
      }
    }
    List<EntityProperty> foreignKeyList = [...entity.properties];
    foreignKeyList.removeWhere((property) =>
        property.type != EntityPropertyType.entity &&
        property.type != EntityPropertyType.foreignKey);

    for (int i = 0; i < foreignKeyList.length; i++) {
      EntityProperty property = foreignKeyList[i];
      bool isLastProperty = i == foreignKeyList.length - 1;

      if (property.type == EntityPropertyType.entity) {
        ddl +=
            '\n  CONSTRAINT ${property.key.toLowerCase()}_${entity.name.toLowerCase()}_${property.value?.name.toLowerCase()}_id_fk FOREIGN KEY (${property.key.substring(0, 1).toLowerCase()}id) REFERENCES ${property.value?.name.toLowerCase()} (id)${!isLastProperty ? ',' : ''} \n';
      } else if (property.type == EntityPropertyType.foreignKey) {
        ddl +=
            '\n  CONSTRAINT ${property.key.toLowerCase()}_${entity.name.toLowerCase()}_${property.value?.name.toLowerCase()}_id_fk FOREIGN KEY (${property.key.substring(0, 1).toLowerCase()}id) REFERENCES ${property.key} (id)${!isLastProperty ? ',' : ''} \n';
      }
    }
    ddl += ');\n\n';
    return ddl;
  }

  @override
  String generateEntityDeleteStoredProcedure(Entity entity) {
    String deleteSP =
        'CREATE PROCEDURE ${entity.name}Delete(${entity.name.substring(0, 2).toLowerCase()}Id bigint unsigned) \nBEGIN \n\n DELETE FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;\n\nEND;';
    return deleteSP;
  }

  @override
  String generateEntityGetAllStoredProcedure(Entity entity) {
    List<EntityProperty> tableProperties = [...entity.properties];
    tableProperties.removeWhere(
        (property) => property.type == EntityPropertyType.foreignKey);
    String body =
        'CREATE PROCEDURE ${entity.name}GetAll() \nBEGIN \n\n SELECT JSON_ARRAYAGG(JSON_OBJECT(\n';
    for (int i = 0; i < tableProperties.length; i++) {
      EntityProperty property = tableProperties[i];
      bool isLastProperty = i == tableProperties.length - 1;
      if (property.type == EntityPropertyType.entity) {
        body +=
            generateInnerSelectNested(property.value as Entity, entity.name);
        isLastProperty ? '' : body += ',';
      } else if (property.type == EntityPropertyType.list) {
        body += generateInnerSelectArray(property.value as Entity, entity.name);
        isLastProperty ? '' : body += ',';
      } else if (property.type != EntityPropertyType.foreignKey) {
        body +=
            "   '${property.key}', ${property.key}${!isLastProperty ? ',' : ''}\n";
      } else {
        continue;
      }
    }
    body +=
        ' )\n ) FROM ${entity.name} ${entity.name.substring(0, 3).toLowerCase()};\n\nEND;\n\n';
    return body;
  }

  @override
  String generateEntityGetByIdStoredProcedure(Entity entity) {
    List<EntityProperty> tableProperties = [...entity.properties];
    tableProperties.removeWhere(
        (property) => property.type == EntityPropertyType.foreignKey);
    String body =
        'CREATE PROCEDURE ${entity.name}GetById(${entity.name.substring(0, 2).toLowerCase()}Id bigint unsigned) \nBEGIN\n\n';
    body += 'SELECT JSON_OBJECT(\n';
    for (int i = 0; i < tableProperties.length; i++) {
      EntityProperty property = tableProperties[i];
      bool isLastProperty = i == tableProperties.length - 1;
      if (property.type == EntityPropertyType.entity) {
        body +=
            generateInnerSelectNested(property.value as Entity, entity.name);
        isLastProperty ? '' : body += ',';
      } else if (property.type == EntityPropertyType.list) {
        body += generateInnerSelectArray(property.value as Entity, entity.name);
        isLastProperty ? '' : body += ',';
      } else if (property.type == EntityPropertyType.foreignKey) {
        //generateInnerSelectArray(property.value as Entity, entity.name);
      } else {
        body +=
            "   '${property.key}', ${property.key}${!isLastProperty ? ',' : ''}\n";
      }
    }
    body +=
        ')\n FROM ${entity.name} ${entity.name.substring(0, 3)} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;';
    body += '\n\nEND;';
    return body;
  }

  @override
  String generateEntityInsertStoredProcedure(Entity entity) {
    List<EntityProperty> tableProperties = [...entity.properties];
    tableProperties
        .removeWhere((property) => property.type == EntityPropertyType.list);
    String ddl =
        'CREATE PROCEDURE ${entity.name}Create(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n';
    if (entity.properties
        .any((property) => property.type == EntityPropertyType.list)) {
      ddl += ' DECLARE i INT; \n SET i = 0;\n\n';
    }
    for (EntityProperty property in tableProperties) {
      if (property.type == EntityPropertyType.foreignKey) {
        ddl +=
            ' SET @var${property.key.toUpperCase()} = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.${property.key.toLowerCase().substring(0, 1)}id\');\n';
      } else {
        ddl +=
            ' SET @var${property.key.toUpperCase()} = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.${property.key.toLowerCase()}\');\n';
      }
    }
    for (EntityProperty property in tableProperties) {
      if (property.type == EntityPropertyType.entity) {
        ddl +=
            '\n CALL ${property.value?.name}Create(@var${property.key.toUpperCase()});\n';
        ddl += ' SET @var${property.key.toUpperCase()}Id = LAST_INSERT_ID();\n';
      }
    }
    ddl += '\n INSERT INTO ${entity.name} (\n';
    for (int i = 0; i < tableProperties.length; i++) {
      EntityProperty property = tableProperties[i];
      bool isLastProperty = i == tableProperties.length - 1;
      if (property.type == EntityPropertyType.foreignKey) {
        ddl +=
            '   ${property.key.substring(0, 1)}id${!isLastProperty ? ',' : ''}\n';
      } else if (property.type != EntityPropertyType.entity) {
        ddl += '   ${property.key}${!isLastProperty ? ',' : ''}\n';
      } else {
        ddl +=
            '   ${property.key.substring(0, 1).toLowerCase()}id${!isLastProperty ? ',' : ''}\n';
      }
    }
    ddl += '\n ) VALUES (\n';
    for (int i = 0; i < tableProperties.length; i++) {
      EntityProperty property = tableProperties[i];
      bool isLastProperty = i == tableProperties.length - 1;
      if (property.type != EntityPropertyType.entity) {
        ddl +=
            '   JSON_UNQUOTE(@var${property.key.toUpperCase()})${!isLastProperty ? ',' : ''}\n';
      } else if (property.type != EntityPropertyType.foreignKey) {
        ddl +=
            '   @var${property.key.toUpperCase()}Id${!isLastProperty ? ',' : ''}\n';
      } else {
        ddl +=
            '   @var${property.key.toUpperCase()}Id${!isLastProperty ? ',' : ''}\n';
      }
    }

    ddl += '\n );\n\n';

    if (entity.properties
        .any((property) => property.type == EntityPropertyType.list)) {
      String entryId = '@${entity.name.substring(0, 2).toLowerCase()}Id';
      ddl += ' SET $entryId = LAST_INSERT_ID();\n\n';
      List<EntityProperty> tableProperties = [...entity.properties];
      tableProperties
          .removeWhere((property) => property.type != EntityPropertyType.list);
      for (EntityProperty property in tableProperties) {
        ddl +=
            ' IF JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, CONCAT(\'\$.${property.key.toLowerCase()}[\', i, \']\')) IS NOT NULL THEN\n  REPEAT\n';
        ddl +=
            'SET @cursor = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, CONCAT(\'\$.${property.key.toLowerCase()}[\', i, \']\'));';
        ddl +=
            ' SET @cursor = JSON_SET(@cursor, \'\$.${entity.name.substring(0, 1)}id\', $entryId);\n';
        ddl += ' CALL ${property.value?.name}Create(@cursor);\n';
        ddl += ' SET i = i + 1;\n';
        ddl +=
            ' UNTIL JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, CONCAT(\'\$.${property.key.toLowerCase()}[\', i, \']\')) IS NULL END REPEAT;\nEND IF;\n\n';
      }
    }

    ddl += 'END;';
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
    for (EntityProperty property in entity.properties) {
      if (property.type == EntityPropertyType.entity) {
        ddl +=
            '\n CALL ${property.value?.name}Update(@var${property.key.toUpperCase()});\n';
      }
    }
    ddl += '\n UPDATE ${entity.name} SET\n';
    List<EntityProperty> tableProperties = [...entity.properties];
    tableProperties.removeWhere(
        (property) => property.type == EntityPropertyType.foreignKey);
    for (int i = 0; i < tableProperties.length; i++) {
      EntityProperty property = tableProperties[i];
      bool isLastProperty = i == tableProperties.length - 1;
      bool nextPropertyIsEntity = i < tableProperties.length - 1 &&
          entity.properties[i + 1].type == EntityPropertyType.entity;
      if (property.type != EntityPropertyType.entity &&
          property.type != EntityPropertyType.foreignKey) {
        ddl +=
            '   ${property.key} = JSON_UNQUOTE(@var${property.key.toUpperCase()})${!isLastProperty && !nextPropertyIsEntity ? ',\n' : ''}';
      }
    }
    ddl += ' WHERE id = @${entity.name.substring(0, 2).toLowerCase()}Id;';
    ddl += '\n\nEND;';
    return ddl;
  }

  @override
  String generateEntityStoredProcedures(Entity entity) {
    String ddl = '';
    ddl += generateEntityInsertStoredProcedure(entity);
    ddl += '\n\n';
    // ddl += generateEntityUpdateStoredProcedure(entity);
    // ddl += '\n\n';
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
        return 'SMALLINT';
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

  String generateInnerSelectNested(Entity entity, String parentName) {
    String returnString = '   \'${entity.name}\', (';
    returnString += 'SELECT JSON_OBJECT(\n';
    for (int i = 0; i < entity.properties.length; i++) {
      EntityProperty property = entity.properties[i];
      bool isLastProperty = i == entity.properties.length - 1;
      returnString +=
          "      '${property.key}', ${property.key}${!isLastProperty ? ',' : ''}\n";
    }
    returnString +=
        ')\n FROM ${entity.name} ${entity.name.substring(0, 3)} WHERE ${entity.name.substring(0, 3).toLowerCase()}.id = ${parentName.substring(0, 3).toLowerCase()}.${entity.name.substring(0, 1)}id)';
    return returnString;
  }

  String generateInnerSelectArray(Entity entity, String parentName) {
    String returnString = '   \'${entity.name}\', (';
    returnString += 'SELECT JSON_ARRAYAGG(JSON_OBJECT(\n';
    List<EntityProperty> tableProperties = [...entity.properties];
    tableProperties.removeWhere(
        (property) => property.type == EntityPropertyType.foreignKey);
    for (int i = 0; i < tableProperties.length; i++) {
      EntityProperty property = tableProperties[i];
      bool isLastProperty = i == tableProperties.length - 1;
      if (property.type == EntityPropertyType.list) {
        returnString +=
            generateInnerSelectArray(property.value as Entity, entity.name);
      } else if (property.type == EntityPropertyType.entity) {
        returnString +=
            generateInnerSelectNested(property.value as Entity, entity.name);
      } else {
        returnString +=
            "      '${property.key}', ${property.key}${!isLastProperty ? ',' : ''}\n";
      }
    }
    returnString +=
        '))\n FROM ${entity.name} ${entity.name.substring(0, 3)} WHERE ${entity.name.substring(0, 3).toLowerCase()}.${parentName.substring(0, 1).toLowerCase()}id = ${parentName.substring(0, 3).toLowerCase()}.id)';
    return returnString;
  }

  String byIdFooter(Entity entity) {
    return ')\n FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;';
  }

  String byIdBody(EntityProperty property) {
    return "      '${property.key}', ${property.key},\n";
  }

  String selectJson() {
    return 'SELECT JSON_OBJECT(\n';
  }

  String _generatePrimaryKey() {
    String primaryKeyName = '';
    String primaryKeySize = '';
    String primaryKeyStrategy = '';
    primaryKeyName = 'id';
    primaryKeySize = 'AUTO_INCREMENT';
    primaryKeyStrategy = 'BIGINT UNSIGNED';
    return '$primaryKeyName $primaryKeyStrategy NOT NULL $primaryKeySize PRIMARY KEY UNIQUE,\n';
  }
}
