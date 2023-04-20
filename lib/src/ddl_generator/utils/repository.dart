import 'package:jbase_package/jbase_package.dart';

String stringRepo(Entity entity, String value, DatabaseType databaseType) {
  switch (databaseType) {
    case DatabaseType.mysql:
      dynamic body = mySqlRepo(value, entity);
      return body[0];
    case DatabaseType.postgresql:
      return 'package:jbase_package/src/repository/postgresql_repository.dart';
    case DatabaseType.sqlserver:
      return 'package:jbase_package/src/repository/sqlserver_repository.dart';
    default:
      return 'package:jbase_package/src/repository/mysql_repository.dart';
  }
}

mySqlRepo(String value, Entity entity) {
  return {
    'createTableHeader': 'CREATE TABLE ${entity.name.toLowerCase()} (\n',
    'createTableBaseColumn': entity.properties.map((property) => property
                .type ==
            EntityPropertyType.entity
        ? '${property.key.substring(0, 1).toLowerCase()}id BIGINT UNSIGNED NOT NULL,\n'
        : '   ${property.key.toLowerCase()} ${mySQLTypeConversion(property.type)},\n'),
    'createTableConstraints': entity.properties.map((property) => property
                .type ==
            EntityPropertyType.entity
        ? '\n  CONSTRAINT ${property.key.toLowerCase()}_${entity.name.toLowerCase()}_${property.value?.name.toLowerCase()}_id_fk FOREIGN KEY (${property.key.substring(0, 1).toLowerCase()}id) REFERENCES ${property.value?.name.toLowerCase()} (id); \n'
        : ''),
    'createProcedureHeader':
        'CREATE PROCEDURE ${entity.name}Create(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n',
    'createProcedureInsertClause': '\n\n INSERT INTO ${entity.name} (\n',
    'createProcedureColumnBody':
        entity.properties.map((property) => '   ${property.key},\n'),
    'createProcedureValuesClause': '\n ) VALUES (\n',
    'createProcedureValueBody': entity.properties.map(
        (property) => '   JSON_UNQUOTE(@var${property.key.toUpperCase()}),\n'),
    'createProcedureFooter': '\n );\n\nEND',
    'updateProcedureHeader':
        'CREATE PROCEDURE ${entity.name}Update(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n',
    'updateProcedureEntityClause': '\n\n UPDATE ${entity.name} SET\n',
    'updateProcedureBody': entity.properties.map((property) =>
        '   ${property.key} = JSON_UNQUOTE(@var${property.key.toUpperCase()}),\n'),
    'updateProcedureWhereClause':
        '\n WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;',
    'deleteProcedure':
        'CREATE PROCEDURE ${entity.name}Delete(${entity.name.substring(0, 2).toLowerCase()}Id bigint unsigned) \nBEGIN \n\n DELETE FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;\n\nEND',
    'getAllProcedureHeader':
        'CREATE PROCEDURE ${entity.name}GetAll() \nBEGIN \n\n SELECT JSON_ARRAYAGG(JSON_OBJECT(\n',
    'getByIdProcedureHeader':
        'CREATE PROCEDURE ${entity.name}GetById(${entity.name.substring(0, 2).toLowerCase()}Id BIGINT UNSIGNED)\nBEGIN\n\n',
    'getByIdProcedureBody': entity.properties
        .map((property) => property.type == EntityPropertyType.entity
            ? {
                // ignore: prefer_interpolation_to_compose_strings
                "'${property.key}', (SELECT JSON_OBJECT(\n " +
                    mySqlRepo(
                        'getByIdProcedureBody', property.value as Entity) +
                    "   )\n FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;"
              }
            : "'${property.key}', ${property.key},\n'"),
    'getByIdProcedureFooter':
        '   )\n FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;',
    'procedureJsonExtract': entity.properties.map((property) =>
        ' SET @var${property.key.toUpperCase()} = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.${property.key.toLowerCase()}\');\n'),
    'footer': '\n\nEND',
  };
}

String mySQLTypeConversion(EntityPropertyType type) {
  switch (type) {
    case EntityPropertyType.string:
      return 'TEXT';
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
