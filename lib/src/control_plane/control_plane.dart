import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/ddl_generator/dbms/database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/dbms/mysql_database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/dbms/oracle_database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/dbms/postgres_database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/dbms/sql_server_database_management_system.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

class ControlPlane {
  late EntityRepository _entityRepository;
  late DatabaseManagementSystem _databaseManagementSystem;
  late ControlPlaneSetting _controlPlaneSetting;

  ControlPlane(ControlPlaneSetting controlPlaneSetting) {
    _controlPlaneSetting = controlPlaneSetting;
    _entityRepository = EntityRepository();
    _databaseManagementSystem =
        MYSQLDatabaseManagementSystem(_controlPlaneSetting);
  }

  get entities => _entityRepository.entities;

  ControlPlaneSetting get setting => _controlPlaneSetting;

  void setSetting(ControlPlaneSetting controlPlaneSetting) {
    _controlPlaneSetting = controlPlaneSetting;
    switch (controlPlaneSetting.databaseType) {
      case DatabaseType.mysql:
        _databaseManagementSystem =
            MYSQLDatabaseManagementSystem(_controlPlaneSetting);
        break;
      case DatabaseType.postgresql:
        _databaseManagementSystem =
            PostgresDatabaseManagementSystem(_controlPlaneSetting);
        break;
      case DatabaseType.oracle:
        _databaseManagementSystem =
            OracleDatabaseManagementSystem(_controlPlaneSetting);
        break;
      case DatabaseType.sqlserver:
        _databaseManagementSystem =
            SQLServerDatabaseManagementSystem(_controlPlaneSetting);
        break;
    }
  }

  void addEntity(String name, String json) {
    _entityRepository.addEntity(name, json);
  }

  String allEntities() {
    return _entityRepository.entities.toString();
  }

  void removeEntity(String name) {
    _entityRepository.removeEntity(name);
  }

  String generateDDL() {
    // return _entityRepository.entities.map((entity) {
    //   return _databaseManagementSystem.generate(entity);
    // }).join('\n');
    return '';
  }

  String generateIndividualDDL(Entity entity) {
    return _databaseManagementSystem.generateDDL(entity);
  }
}
