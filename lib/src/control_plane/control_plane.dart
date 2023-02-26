import 'package:jbase_package/src/ddl_generator/ddl_generator.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

class ControlPlane {
  final EntityRepository _entityRepository = EntityRepository();
  final DDLGenerator _ddlGenerator = DDLGenerator();

  void addEntity(String name, String json) {
    _entityRepository.addEntity(name, json);
  }

  String generateDDL() {
    return _entityRepository.entities.map((entity) {
      return _ddlGenerator.generate(entity);
    }).join('\n');
  }
}
