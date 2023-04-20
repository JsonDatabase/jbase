import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/database/database_connection.dart';
import 'package:mysql_client/mysql_client.dart';

class MYSQLDatabaseConnection implements DatabaseConnection {
  @override
  DatabaseCredential credential;

  MYSQLDatabaseConnection(this.credential);

  Future<MySQLConnection> _createConnection() async {
    return await MySQLConnection.createConnection(
      host: credential.host,
      port: int.parse(credential.port),
      userName: credential.username,
      password: credential.password,
      databaseName: credential.database,
    );
  }

  @override
  Future<bool> execute(String query, Map<String, dynamic> params) async {
    try {
      MySQLConnection connection = await _createConnection();
      await connection.connect();
      await connection.execute(query, params);
      await connection.close();
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> testConnection() async {
    try {
      MySQLConnection connection = await _createConnection();
      await connection.connect();
      await connection.close();
      return true;
    } catch (error) {
      return false;
    }
  }
}
