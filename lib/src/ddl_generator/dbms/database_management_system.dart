import 'package:jbase_package/jbase_package.dart';

abstract class DatabaseManagementSystem {
  DatabaseManagementSystem(ControlPlaneSetting controlPlaneSetting);

  String generateEntityDDL(Entity entity);
  String generateEntityStoredProcedures(Entity entity);
  String generateEntityGetAllStoredProcedure(Entity entity);
  String generateEntityGetByIdStoredProcedure(Entity entity);
  String generateEntityInsertStoredProcedure(Entity entity);
  String generateEntityUpdateStoredProcedure(Entity entity);
  String generateEntityDeleteStoredProcedure(Entity entity);

  String generateExecutableEntityDDL(Entity entity);

  List<String> columnDataTypes();

  String entityPropertyTypeToColumnDataType(EntityPropertyType type);
}
