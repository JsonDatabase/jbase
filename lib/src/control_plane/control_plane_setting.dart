class ControlPlaneSetting {
  factory ControlPlaneSetting(
      {DatabaseType databaseType = DatabaseType.mysql,
      PrimaryKeyStrategy primaryKeyStrategy = PrimaryKeyStrategy.auto,
      PrimaryKeyIncrementStrategy primaryKeyIncrementStrategy =
          PrimaryKeyIncrementStrategy.auto,
      PrimaryKeySizeStrategy primaryKeySizeStrategy =
          PrimaryKeySizeStrategy.auto,
      DatabaseCredential? databaseCredential,
      DatabaseCredentialStorage databaseCredentialStorage =
          DatabaseCredentialStorage.inMemory}) {
    return ControlPlaneSetting._(
        databaseType: databaseType,
        primaryKeyStrategy: primaryKeyStrategy,
        primaryKeyIncrementStrategy: primaryKeyIncrementStrategy,
        primaryKeySizeStrategy: primaryKeySizeStrategy,
        databaseCredential: databaseCredential ?? DatabaseCredential.empty(),
        databaseCredentialStorage: databaseCredentialStorage);
  }

  ControlPlaneSetting._(
      {required this.databaseType,
      required this.primaryKeyStrategy,
      required this.primaryKeyIncrementStrategy,
      required this.primaryKeySizeStrategy,
      required this.databaseCredential,
      required this.databaseCredentialStorage});

  DatabaseType databaseType = DatabaseType.mysql;
  PrimaryKeyStrategy primaryKeyStrategy = PrimaryKeyStrategy.auto;
  PrimaryKeyIncrementStrategy primaryKeyIncrementStrategy =
      PrimaryKeyIncrementStrategy.auto;
  PrimaryKeySizeStrategy primaryKeySizeStrategy = PrimaryKeySizeStrategy.auto;
  DatabaseCredential databaseCredential = DatabaseCredential.empty();
  DatabaseCredentialStorage databaseCredentialStorage =
      DatabaseCredentialStorage.inMemory;

  Map<String, dynamic> toMap() {
    return {
      'databaseType': databaseType.toString(),
      'primaryKeyStrategy': primaryKeyStrategy.toString(),
      'primaryKeyIncrementStrategy': primaryKeyIncrementStrategy.toString(),
      'primaryKeySizeStrategy': primaryKeySizeStrategy.toString(),
      'databaseCredentialStorage': databaseCredentialStorage.toString(),
    };
  }
}

class DatabaseCredential {
  DatabaseCredential({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.database,
  });

  DatabaseCredential.empty();

  String host = '';
  String port = '';
  String username = '';
  String password = '';
  String database = '';

  Map<String, dynamic> toMap() {
    return {
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'database': database,
    };
  }

  factory DatabaseCredential.fromMap(Map<String, dynamic> map) {
    return DatabaseCredential(
      host: map['host'],
      port: map['port'],
      username: map['username'],
      password: map['password'],
      database: map['database'],
    );
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
