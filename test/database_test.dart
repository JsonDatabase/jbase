import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_client/mysql_client.dart';

void main() {
  test('Full Test', () async {
    final conn = await MySQLConnection.createConnection(
      host: "localhost",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "jbase_testing",
    );
    await conn.connect();
    var result = await conn.execute("SHOW TABLES;", {});
    for (final row in result.rows) {
      print(row.assoc());
    }
  });
}
