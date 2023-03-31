import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/ddl_generator/ddl_generator.dart';
import 'package:jbase_package/src/entity_repository/entity.dart';
import 'package:jbase_package/src/entity_repository/entity_repository.dart';

class ControlPlane {
  late EntityRepository _entityRepository;
  late DDLGenerator _ddlGenerator;
  late ControlPlaneSetting _controlPlaneSetting;
  ControlPlane(ControlPlaneSetting controlPlaneSetting) {
    _controlPlaneSetting = controlPlaneSetting;
    _entityRepository = EntityRepository();
    _ddlGenerator = DDLGenerator(_controlPlaneSetting);
  }

  get entities => _entityRepository.entities;

  ControlPlaneSetting get setting => _controlPlaneSetting;

  void setSetting(ControlPlaneSetting controlPlaneSetting) {
    _controlPlaneSetting = controlPlaneSetting;
    _ddlGenerator = DDLGenerator(_controlPlaneSetting);
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
    return _entityRepository.entities.map((entity) {
      return _ddlGenerator.generate(entity);
    }).join('\n');
  }

  String generateIndividualDDL(Entity entity) {
    return _ddlGenerator.generate(entity);
  }
  
}
