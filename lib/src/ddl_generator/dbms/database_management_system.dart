import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

abstract class DatabaseManagementSystem {
  DatabaseManagementSystem(ControlPlaneSetting controlPlaneSetting);

  String generateEntityDDL(Entity entity);
  String generateEntityStoredProcedures(Entity entity);
  String generateEntityGetAllStoredProcedure(Entity entity);
  String generateEntityGetByIdStoredProcedure(Entity entity);
  String generateEntityInsertStoredProcedure(Entity entity);
  String generateEntityUpdateStoredProcedure(Entity entity);
  String generateEntityDeleteStoredProcedure(Entity entity);

  String generateExecutableEntityDDL(EntityRepository entityRepository);

  List<String> columnDataTypes();

  String entityPropertyTypeToColumnDataType(EntityPropertyType type);
}
