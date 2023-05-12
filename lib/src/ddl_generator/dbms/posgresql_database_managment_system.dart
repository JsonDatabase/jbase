import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/ddl_generator/dbms/database_management_system.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';

class POSGRESQLDatabaseManagementSystem extends DatabaseManagementSystem {
  ControlPlaneSetting controlPlaneSetting;
  POSGRESQLDatabaseManagementSystem(this.controlPlaneSetting)
      : super(controlPlaneSetting);

  @override
  List<String> columnDataTypes() {
    return [
      'BOOLEAN',
      'SMALLINT',
      'INTEGER',
      'BIGINT',
      'DECIMAL',
      'NUMERIC',
      'REAL',
      'DOUBLE PRECISION',
      'DATE',
      'TIME',
      'TIMESTAMP',
      'INTERVAL',
      'CHAR',
      'VARCHAR',
      'TEXT',
      'UUID',
      'JSON',
      'JSONB',
      'XML',
      'BYTEA',
      'ARRAY',
      'HSTORE',
      'OID',
      'CIDR',
      'INET',
      'MACADDR',
      'TSVECTOR',
      'TSQUERY',
      'POINT',
      'LINE',
      'LSEG',
      'BOX',
      'PATH',
      'POLYGON',
      'CIRCLE',
      'BIT',
      'VARBIT'
    ];
  }

  @override
  String entityPropertyTypeToColumnDataType(EntityPropertyType type) {
    switch (type) {
      case EntityPropertyType.bool:
        return 'BOOLEAN';
      case EntityPropertyType.int:
        return 'INTEGER';
      case EntityPropertyType.double:
        return 'DOUBLE PRECISION';
      case EntityPropertyType.string:
        return 'TEXT';
      case EntityPropertyType.entity:
        return 'FOREIGN KEY (Single)';
      case EntityPropertyType.list:
        return 'FOREIGN KEY (Multiple)';
      default:
        return '';
    }
  }

  @override
  String generateEntityDDL(Entity entity) {
    bool primaryKeys = false;
    String ddl = 'CREATE TABLE ${entity.name} (\n';
    ddl += _generatePrimaryKeyPostgreSQL();
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
            '  ${property.key.substring(0, 1).toLowerCase()}id BIGINT NOT NULL,\n';
      } else if (property.type == EntityPropertyType.list) {
        continue;
      } else if (property.type == EntityPropertyType.foreignKey) {
        hasForeignKey = true;
        ddl +=
            '  ${property.key.substring(0, 1).toLowerCase()}id BIGINT NOT NULL,\n';
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
  String generateExecutableEntityDDL(EntityRepository entityRepository) {
    String ddl = '';
    for (Entity entity in entityRepository.entities) {
      ddl += generateEntityDDL(entity);
    }
    return ddl;
  }
}

String _generatePrimaryKeyPostgreSQL() {
  return 'id SERIAL PRIMARY KEY,\n';
}
