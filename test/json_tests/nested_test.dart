import 'package:flutter_test/flutter_test.dart';
import 'package:jbase_package/jbase_package.dart';
import 'package:jbase_package/src/control_plane/control_plane_setting.dart';

void main() {
  test('Single Nested Object', () {
    ControlPlane controlPlane = ControlPlane(ControlPlaneSetting());
    controlPlane.addEntity('Person',
        '{"name": "John", "age": 30, "over_18": true, "height": 1.8, "address": {"street": "123 Main St", "city": "Anytown", "state": "CA", "zip": "12345"}}');
    String ddl = controlPlane.generateDDL();
    expect(
        ddl,
        'CREATE TABLE address (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  street VARCHAR (250),\n'
        '  city VARCHAR (250),\n'
        '  state VARCHAR (250),\n'
        '  zip VARCHAR (250),\n'
        ');\n'
        '\n'
        'CREATE TABLE Person (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  name VARCHAR (250),\n'
        '  age INT,\n'
        '  over_18 SMALLINT,\n'
        '  height DOUBLE(10,2),\n'
        '  aid BIGINT UNSIGNED NOT NULL,\n'
        '\n'
        '  CONSTRAINT person_address_id_fk FOREIGN KEY (aid) REFERENCES address (id);\n'
        ');\n');
  });

  test('Double Nested Object', () {
    ControlPlane controlPlane = ControlPlane(ControlPlaneSetting());
    controlPlane.addEntity('Person',
        '{"name": "John", "age": 30, "over_18": true, "height": 1.8, "address": {"street": "123 Main St", "city": "Anytown", "state": "CA", "zip": { "code": 12345, "subcode": 6789 }}}');
    String ddl = controlPlane.generateDDL();
    expect(
        ddl,
        'CREATE TABLE zip (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  code INT,\n'
        '  subcode INT,\n'
        ');\n'
        '\n'
        'CREATE TABLE address (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  street VARCHAR (250),\n'
        '  city VARCHAR (250),\n'
        '  state VARCHAR (250),\n'
        '  zid BIGINT UNSIGNED NOT NULL,\n'
        '\n'
        '  CONSTRAINT address_zip_id_fk FOREIGN KEY (zid) REFERENCES zip (id);\n'
        ');\n'
        '\n'
        'CREATE TABLE Person (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  name VARCHAR (250),\n'
        '  age INT,\n'
        '  over_18 SMALLINT,\n'
        '  height DOUBLE(10,2),\n'
        '  aid BIGINT UNSIGNED NOT NULL,\n'
        '\n'
        '  CONSTRAINT person_address_id_fk FOREIGN KEY (aid) REFERENCES address (id);\n'
        ');\n');
  });

  test('Colliding Nested Object', () {
    ControlPlane controlPlane = ControlPlane(ControlPlaneSetting());
    controlPlane.addEntity('Person',
        '{"name": "John", "age": 30, "over_18": true, "height": 1.8, "address": {"street": "123 Main St", "city": "Anytown", "state": "CA", "zip": { "code": 12345, "subcode": 6789 }}, "shipping_address": {"street": "123 Main St", "city": "Anytown", "state": "CA", "zip": { "code": 12345, "subcode": 6789 }}}');
    String ddl = controlPlane.generateDDL();
    expect(
        ddl,
        'CREATE TABLE zip (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  code INT,\n'
        '  subcode INT,\n'
        ');\n'
        '\n'
        'CREATE TABLE address (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  street VARCHAR (250),\n'
        '  city VARCHAR (250),\n'
        '  state VARCHAR (250),\n'
        '  zid BIGINT UNSIGNED NOT NULL,\n'
        '\n'
        '  CONSTRAINT zip_address_zip_id_fk FOREIGN KEY (zid) REFERENCES zip (id);\n'
        ');\n'
        '\n'
        'CREATE TABLE Person (\n'
        '  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY UNIQUE,\n'
        '  name VARCHAR (250),\n'
        '  age INT,\n'
        '  over_18 SMALLINT,\n'
        '  height DOUBLE(10,2),\n'
        '  aid BIGINT UNSIGNED NOT NULL,\n'
        '  sid BIGINT UNSIGNED NOT NULL,\n'
        '\n'
        '  CONSTRAINT address_person_address_id_fk FOREIGN KEY (aid) REFERENCES address (id);\n'
        '\n'
        '  CONSTRAINT shipping_address_person_address_id_fk FOREIGN KEY (sid) REFERENCES address (id);\n'
        ');\n');
  });
}
