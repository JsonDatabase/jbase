class ControlPlaneSetting {
  DatabaseType databaseType = DatabaseType.mysql;
  PrimaryKeyStrategy primaryKeyStrategy = PrimaryKeyStrategy.auto;
  PrimaryKeyIncrementStrategy primaryKeyIncrementStrategy =
      PrimaryKeyIncrementStrategy.auto;
  PrimaryKeySizeStrategy primaryKeySizeStrategy = PrimaryKeySizeStrategy.auto;
}

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
