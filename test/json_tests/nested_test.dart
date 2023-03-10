import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/control_plane/control_plane_setting.dart';

void main() {
  test('Full Test', () {
    ControlPlane controlPlane = ControlPlane(ControlPlaneSetting());
    controlPlane.addEntity('Person',
        '{"name": "John", "age": 30, "over_18": true, "height": 1.8, "address": {"street": "123 Main St", "city": "Anytown", "state": "CA", "zip": "12345"}}');
    String ddl = controlPlane.generateDDL();
    print(ddl);
    // expect(ddl,
    //     'CREATE TABLE Person (\n  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n  name VARCHAR (250),\n  age INT,\n  over_18 SMALLINT,\n  height DOUBLE(10,2),\n);\nCREATE TABLE Car (\n  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n  make VARCHAR (250),\n  model VARCHAR (250),\n);');
  });
}
