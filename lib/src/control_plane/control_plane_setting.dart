class ControlPlaneSetting {
  factory ControlPlaneSetting(
      {DatabaseType databaseType = DatabaseType.mysql,
      PrimaryKeyStrategy primaryKeyStrategy = PrimaryKeyStrategy.auto,
      PrimaryKeyIncrementStrategy primaryKeyIncrementStrategy =
          PrimaryKeyIncrementStrategy.auto,
      PrimaryKeySizeStrategy primaryKeySizeStrategy =
          PrimaryKeySizeStrategy.auto,
      DatabaseConnection? databaseConnection,
      DatabaseCredentialStorage databaseCredentialStorage =
          DatabaseCredentialStorage.inMemory}) {
    return ControlPlaneSetting._(
        databaseType: databaseType,
        primaryKeyStrategy: primaryKeyStrategy,
        primaryKeyIncrementStrategy: primaryKeyIncrementStrategy,
        primaryKeySizeStrategy: primaryKeySizeStrategy,
        databaseConnection: databaseConnection ?? DatabaseConnection.empty(),
        databaseCredentialStorage: databaseCredentialStorage);
  }

  ControlPlaneSetting._(
      {required this.databaseType,
      required this.primaryKeyStrategy,
      required this.primaryKeyIncrementStrategy,
      required this.primaryKeySizeStrategy,
      required this.databaseConnection,
      required this.databaseCredentialStorage});

  DatabaseType databaseType = DatabaseType.mysql;
  PrimaryKeyStrategy primaryKeyStrategy = PrimaryKeyStrategy.auto;
  PrimaryKeyIncrementStrategy primaryKeyIncrementStrategy =
      PrimaryKeyIncrementStrategy.auto;
  PrimaryKeySizeStrategy primaryKeySizeStrategy = PrimaryKeySizeStrategy.auto;
  DatabaseConnection databaseConnection = DatabaseConnection.empty();
  DatabaseCredentialStorage databaseCredentialStorage =
      DatabaseCredentialStorage.inMemory;

  Map<String, dynamic> toMap() {
    return {
      'databaseType': databaseType.toString(),
      'primaryKeyStrategy': primaryKeyStrategy.toString(),
      'primaryKeyIncrementStrategy': primaryKeyIncrementStrategy.toString(),
      'primaryKeySizeStrategy': primaryKeySizeStrategy.toString(),
      'databaseConnection': databaseConnection.toJson(),
      'databaseCredentialStorage': databaseCredentialStorage.toString(),
    };
  }
}

class DatabaseConnection {
  factory DatabaseConnection({
    required String host,
    required String port,
    required String username,
    required String password,
    required String database,
  }) {
    return DatabaseConnection(
      host: host,
      port: port,
      username: username,
      password: password,
      database: database,
    );
  }

  DatabaseConnection.empty();

  String host = '';
  String port = '';
  String username = '';
  String password = '';
  String database = '';

  Map<String, dynamic> toJson() {
    return {
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'database': database,
    };
  }
}

enum DatabaseCredentialStorage { inMemory, secureLocalStorage }

enum PrimaryKeyIncrementStrategy {
  auto,
  manual,
}

enum PrimaryKeyStrategy { auto, none }

enum PrimaryKeySizeStrategy {
  auto,
}

enum DatabaseType {
  mysql,
  postgresql,
  oracle,
  sqlserver,
}
