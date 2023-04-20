import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/ddl_generator/dbms/database_management_system.dart';
import 'package:jbase_package/src/ddl_generator/utils/repository.dart';

class MYSQLDatabaseManagementSystem extends DatabaseManagementSystem {
  MYSQLDatabaseManagementSystem(super.controlPlaneSetting);

  @override
  String generateDDL(Entity entity) {
    dynamic header =
        stringRepo(entity, 'createTableHeader', DatabaseType.mysql);
    dynamic body =
        stringRepo(entity, 'createTableBaseColumn', DatabaseType.mysql);
    dynamic constraints =
        stringRepo(entity, 'createTableConstraints', DatabaseType.mysql);
    return '$header$body$constraints);\n\n';
  }

  @override
  String generateStoredProcedures(Entity entity) {
    // TODO: implement generateStoredProcedures
    throw UnimplementedError();
  }
}
