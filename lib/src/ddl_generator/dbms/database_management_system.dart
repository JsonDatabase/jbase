import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';

abstract class DatabaseManagementSystem {
  DatabaseManagementSystem(ControlPlaneSetting controlPlaneSetting);

  String generateEntityDDL(Entity entity);
  String generateEntityStoredProcedures(Entity entity);
  String generateEntityGetAllStoredProcedure(Entity entity);
  String generateEntityGetByIdStoredProcedure(Entity entity);
  String generateEntityInsertStoredProcedure(Entity entity);
  String generateEntityUpdateStoredProcedure(Entity entity);
  String generateEntityDeleteStoredProcedure(Entity entity);

  List<String> columnDataTypes();
}
