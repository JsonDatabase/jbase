import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';

abstract class DatabaseManagementSystem {
  DatabaseManagementSystem(ControlPlaneSetting controlPlaneSetting);
  String generateDDL(Entity entity);
  String generateStoredProcedures(Entity entity);
}
