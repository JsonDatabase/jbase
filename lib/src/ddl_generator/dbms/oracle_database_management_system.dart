import 'package:jbase_package/src/ddl_generator/dbms/database_management_system.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';

class OracleDatabaseManagementSystem extends DatabaseManagementSystem {
  OracleDatabaseManagementSystem(super.controlPlaneSetting);

  @override
  String generateDDL(Entity entity) {
    // TODO: implement generateDDL
    throw UnimplementedError();
  }

  @override
  String generateStoredProcedures(Entity entity) {
    // TODO: implement generateStoredProcedures
    throw UnimplementedError();
  }
}
