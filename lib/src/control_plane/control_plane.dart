import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/database/database_connection.dart';
import 'package:jbase_package/src/database/mysql_database_connection.dart';
import 'package:jbase_package/src/database/postgres_connection.dart';
import 'package:jbase_package/src/ddl_generator/dbms/database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/dbms/mysql_database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/dbms/posgresql_database_managment_system.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

class ControlPlane {
  late EntityRepository _entityRepository;
  late DatabaseManagementSystem _databaseManagementSystem;
  late ControlPlaneSetting _controlPlaneSetting;
  late DatabaseConnection _databaseConnection;

  ControlPlane(ControlPlaneSetting controlPlaneSetting) {
    _entityRepository = EntityRepository(this);
    setSetting(controlPlaneSetting);
  }

  List<Entity> get entities => _entityRepository.entities;

  ControlPlaneSetting get setting => _controlPlaneSetting;
  DatabaseManagementSystem get databaseManagementSystem =>
      _databaseManagementSystem;
  void setSetting(ControlPlaneSetting controlPlaneSetting) {
    _controlPlaneSetting = controlPlaneSetting;
    switch (controlPlaneSetting.databaseType) {
      case DatabaseType.mysql:
        _databaseManagementSystem =
            MYSQLDatabaseManagementSystem(_controlPlaneSetting);
        _databaseConnection =
            MYSQLDatabaseConnection(_controlPlaneSetting.databaseCredential);
        break;
      case DatabaseType.postgresql:
        _databaseManagementSystem =
            POSGRESQLDatabaseManagementSystem(_controlPlaneSetting);
        _databaseConnection = PostgreSQLDatabaseConnection(
            _controlPlaneSetting.databaseCredential);
        break;
      case DatabaseType.oracle:
        break;
      case DatabaseType.sqlserver:
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
    return _databaseManagementSystem
        .generateExecutableEntityDDL(_entityRepository);
  }

  String generateIndividualDDL(Entity entity) {
    return _databaseManagementSystem.generateEntityDDL(entity);
  }

  Future<bool> testDatabaseConnection() async {
    return await _databaseConnection.testConnection();
  }

  Future<bool> executeDDL() async {
    return await _databaseConnection.execute(generateDDL(), {});
  }
}
