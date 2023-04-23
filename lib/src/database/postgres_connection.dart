import 'package:postgres/postgres.dart';
import 'package:jbase_package/src/control_plane/control_plane_setting.dart';
import 'package:jbase_package/src/database/database_connection.dart';

class PostgreSQLDatabaseConnection implements DatabaseConnection {
  @override
  DatabaseCredential credential;

  PostgreSQLDatabaseConnection(this.credential);

  Future<PostgreSQLConnection> _createConnection() async {
    return PostgreSQLConnection(
      credential.host,
      int.parse(credential.port),
      credential.database,
      username: credential.username,
      password: credential.password,
    );
  }

  @override
  Future<bool> execute(String query, Map<String, dynamic> params) async {
    try {
      PostgreSQLConnection connection = await _createConnection();
      await connection.open();
      await connection.query(query, substitutionValues: params);
      await connection.close();
      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<bool> testConnection() async {
    try {
      PostgreSQLConnection connection = await _createConnection();
      await connection.open();
      await connection.close();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
