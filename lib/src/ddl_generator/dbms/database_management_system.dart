import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';

abstract class DatabaseManagementSystem {
  DatabaseManagementSystem(ControlPlaneSetting controlPlaneSetting);
  String generateDDL(Entity entity);
  String generateStoredProcedures(Entity entity);
  String generateGetAllStoredProcedure(Entity entity);
  String generateGetByIdStoredProcedure(Entity entity);
  String generateInsertStoredProcedure(Entity entity);
  String generateUpdateStoredProcedure(Entity entity);
  String generateDeleteStoredProcedure(Entity entity);
}
