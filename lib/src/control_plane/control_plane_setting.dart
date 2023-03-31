class ControlPlaneSetting {
  factory ControlPlaneSetting({
    DatabaseType databaseType = DatabaseType.mysql,
    PrimaryKeyStrategy primaryKeyStrategy = PrimaryKeyStrategy.auto,
    PrimaryKeyIncrementStrategy primaryKeyIncrementStrategy =
        PrimaryKeyIncrementStrategy.auto,
    PrimaryKeySizeStrategy primaryKeySizeStrategy = PrimaryKeySizeStrategy.auto,
  }) {
    return ControlPlaneSetting._(
      databaseType: databaseType,
      primaryKeyStrategy: primaryKeyStrategy,
      primaryKeyIncrementStrategy: primaryKeyIncrementStrategy,
      primaryKeySizeStrategy: primaryKeySizeStrategy,
    );
  }

  ControlPlaneSetting._({
    required this.databaseType,
    required this.primaryKeyStrategy,
    required this.primaryKeyIncrementStrategy,
    required this.primaryKeySizeStrategy,
  });

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
