import 'package:jbase_package/jbase_package.dart';

String generateGetAll(Entity entity) {
  String body =
      'CREATE PROCEDURE ${entity.name}GetAll() \nBEGIN \n\n SELECT JSON_ARRAYAGG(JSON_OBJECT(\n';
  entity.properties.forEach((property) {
    body += "   '${property.key}', ${property.key},\n";
  });
  body += '   ))\n FROM ${entity.name};\n\nEND';
  return body;
}

String generateGet(Entity entity) {
  String body =
      'CREATE PROCEDURE ${entity.name}GetById(${entity.name.substring(0, 2).toLowerCase()}Id bigint unsigned) \nBEGIN\n\n';
  body += selectJson();
  entity.properties.forEach((property) {
    if (property.type == EntityPropertyType.entity) {
      body += generateInnerSelect(property.value as Entity);
    } else {
      body += byIdBody(property);
    }
  });
  body += byIdFooter(entity);
  body += '\n\nEND';
  return body;
}

String generateUpdate(Entity entity) {
  String body =
      'CREATE PROCEDURE ${entity.name}Update(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n';
  entity.properties.forEach((property) {
    body +=
        ' SET @var${property.key.toUpperCase()} = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.${property.key.toLowerCase()}\');\n';
  });
  body = body.substring(0, body.length - 1);
  body += '\n\n UPDATE ${entity.name} SET\n';
  entity.properties.forEach((property) {
    body +=
        '   ${property.key} = JSON_UNQUOTE(@var${property.key.toUpperCase()}),\n';
  });
  body = body.substring(0, body.length - 2);
  body +=
      '\n WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;\n\nEND';
  return body;
}

String generateDelete(Entity entity) {
  String body =
      'CREATE PROCEDURE ${entity.name}Delete(${entity.name.substring(0, 2).toLowerCase()}Id bigint unsigned) \nBEGIN \n\n DELETE FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;\n\nEND';
  return body;
}

String generateCreate(Entity entity) {
  String body =
      'CREATE PROCEDURE ${entity.name}Create(${entity.name.substring(0, 2).toLowerCase()}Obj JSON)\nBEGIN\n\n';
  entity.properties.forEach((property) {
    body +=
        'SET @var${property.key.toUpperCase()} = JSON_EXTRACT(${entity.name.substring(0, 2).toLowerCase()}Obj, \'\$.${property.key.toLowerCase()}\');\n';
  });
  body = body.substring(0, body.length - 1);
  body += '\n\n INSERT INTO ${entity.name} (\n';
  entity.properties.forEach((property) {
    body += '   ${property.key},\n';
  });
  body = body.substring(0, body.length - 2);
  body += ' ) VALUES (\n';
  entity.properties.forEach((property) {
    body += '   JSON_UNQUOTE(@var${property.key.toUpperCase()}),\n';
  });
  body = body.substring(0, body.length - 2);
  body += '\n );\n\nEND';
  return body;
}

String byIdFooter(Entity entity) {
  return '   )\n FROM ${entity.name} WHERE id = ${entity.name.substring(0, 2).toLowerCase()}Id;';
}

String byIdBody(EntityProperty property) {
  return "   '${property.key}', ${property.key},\n";
}

String selectJson() {
  return 'SELECT JSON_OBJECT(\n';
}

String generateInnerSelect(Entity entity) {
  String returnString = '\'${entity.name}\', (';
  returnString += selectJson();
  entity.properties.forEach((property) {
    returnString += byIdBody(property);
    if (property.type == EntityPropertyType.entity) {}
  });
  returnString += byIdFooter(entity);
  return returnString;
}
