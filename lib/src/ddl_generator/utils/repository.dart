import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';

String stringRepo(Entity entity, String value, DatabaseType databaseType) {
  switch (databaseType) {
    case DatabaseType.mysql:
      String body = mySqlRepo(value, entity);
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
  return 
    {
      'updateHeader':
          'CREATE PROCEDURE ${entity.name}Update(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n'
    };
}
