import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/ddl_generator/utils/stored_procedures.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_property.dart';

// class DDLGenerator {
//   final ControlPlaneSetting controlPlaneSetting;
//   DDLGenerator(this.controlPlaneSetting);

//   String typeConversion(EntityPropertyType type) {
//     switch (type) {
//       case EntityPropertyType.string:
//         return 'VARCHAR (250)';
//       case EntityPropertyType.int:
//         return 'INT';
//       case EntityPropertyType.double:
//         return 'DOUBLE(10,2)';
//       case EntityPropertyType.bool:
//         return 'SMALLINT';
//       case EntityPropertyType.entity:
//         return '$type';
//     }
//   }

//   String generate(Entity entity) {
//     var foreignKeyRepository = [];

//     var ddl = 'CREATE TABLE ${entity.name.toLowerCase()} (\n';

//     if (controlPlaneSetting.primaryKeyStrategy == PrimaryKeyStrategy.auto) {
//       ddl += '  ${_generatePrimaryKey()},\n';
//     }

//     entity.properties.forEach((element) {
//       if (element.type == EntityPropertyType.entity) {
//         var key = '${element.key.substring(0, 1)}id';
//         var type = 'BIGINT UNSIGNED';
//         var nullable = 'NOT NULL';
//         ddl += '  ${key.toLowerCase()} $type $nullable,\n';

//         foreignKeyRepository.add(
//             'CONSTRAINT ${element.key.toLowerCase()}_${entity.name.toLowerCase()}_${element.value?.name.toLowerCase()}_id_fk FOREIGN KEY (${key.toLowerCase()}) REFERENCES ${element.value?.name.toLowerCase()} (id);');
//       } else {
//         var key = element.key;
//         var type = element.type;
//         ddl += '  ${key.toLowerCase()} ${typeConversion(type)},\n';
//       }
//     });

//     foreignKeyRepository.forEach((element) {
//       ddl += '\n  $element\n';
//     });

//     ddl += ');\n\n';

//     ddl += generateStoredProcedures(entity);
//     ddl += '\n\n';
//     ddl += generateGet(entity);
//     ddl += '\n\n';
//     ddl += generateCreate(entity);
//     ddl += '\n\n';
//     ddl += generateUpdate(entity);
//     ddl += '\n\n';
//     ddl += generateDelete(entity);
//     ddl += '\n\n';

//     ddl += '\n';

//     return ddl;
//   }

//   String generateStoredProcedures(Entity entity) {
//     return generateGetAll(entity);
//   }

//   String generateAll(List<Entity> entities) {
//     return entities.map((entity) => generate(entity)).join('\n');
//   }

//   String _generatePrimaryKey() {
//     String primaryKeyName = '';
//     String primaryKeySize = '';
//     String primaryKeyStrategy = '';
//     if (controlPlaneSetting.primaryKeyStrategy == PrimaryKeyStrategy.auto) {
//       primaryKeyName = 'id';
//     }
//     if (controlPlaneSetting.primaryKeyIncrementStrategy ==
//         PrimaryKeyIncrementStrategy.auto) {
//       primaryKeySize = 'AUTO_INCREMENT';
//     }

//     if (controlPlaneSetting.primaryKeySizeStrategy ==
//         PrimaryKeySizeStrategy.auto) {
//       primaryKeyStrategy = 'BIGINT UNSIGNED';
//     }

//     return '$primaryKeyName $primaryKeyStrategy NOT NULL $primaryKeySize PRIMARY KEY UNIQUE';
//   }
// }
