import 'package:mysql1/mysql1.dart';

class DatabaseConnection {
  var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'bob',
      password: 'wibble',
      db: 'mydb');
}
