class ControlPlaneSetting {
  DatabaseType databaseType = DatabaseType.mysql;
}

enum DatabaseType {
  mysql,
  postgresql,
  oracle,
  sqlserver,
}
