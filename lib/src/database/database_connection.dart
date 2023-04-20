import 'package:jbase_package/src/control_plane/control_plane_setting.dart';

abstract class DatabaseConnection {
  DatabaseCredential credential;
  DatabaseConnection(this.credential);
  Future<bool> testConnection();
  Future<bool> execute(String query, Map<String, dynamic> params);
}
