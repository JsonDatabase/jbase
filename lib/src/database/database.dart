import 'package:mysql_client/mysql_client.dart';

class DatabaseConnection {
  String host = "localhost";
  int port = 3306;
  String username = "";
  String password = "";
  String database = "";
  late MySQLConnection connection;
  bool connected = false;

  DatabaseConnection();

  Future<MySQLConnection> createConnection() async {
    return await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: username,
      password: password,
      databaseName: database,
    );
  }

  void setHost(String newHost) {
    host = newHost;
  }

  void setPort(int newPort) {
    port = newPort;
  }

  void setUsername(String newUsername) {
    username = newUsername;
  }

  void setPassword(String newPassword) {
    password = newPassword;
  }

  void setDatabase(String newDatabase) {
    database = newDatabase;
  }

  Future<void> connect() async {
    if (connected) {
      return;
    }
    connection = await createConnection();
    try {
      await connection.connect();
      connected = true;
    } catch (e) {
      print(e);
    }
  }

  void disconnect() async {
    await connection.close();
    connected = false;
  }

  Future<IResultSet> execute(String query, Map<String, dynamic> params) async {
    if (!connected) {
      return Future.error("Not connected to database");
    }
    return await connection.execute(query, params);
  }
}
