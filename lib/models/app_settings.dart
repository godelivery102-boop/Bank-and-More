class AppSettings {
  const AppSettings({
    this.appName = 'Bank and More',
    this.enableLogin = false,
    this.darkMode = false,
    this.followSystemTheme = true,
    this.adminUsername = 'admin',
    this.adminPassword = '123456',
    this.showDashboard = true,
    this.showLocation = true,
    this.showOrderExpress = true,
    this.showAllRecords = true,
    this.showInventory = true,
    this.showSettings = true,
  });

  final String appName;
  final bool enableLogin;
  final bool darkMode;
  final bool followSystemTheme;
  final String adminUsername;
  final String adminPassword;
  final bool showDashboard;
  final bool showLocation;
  final bool showOrderExpress;
  final bool showAllRecords;
  final bool showInventory;
  final bool showSettings;

  AppSettings copyWith({
    String? appName,
    bool? enableLogin,
    bool? darkMode,
    bool? followSystemTheme,
    String? adminUsername,
    String? adminPassword,
    bool? showDashboard,
    bool? showLocation,
    bool? showOrderExpress,
    bool? showAllRecords,
    bool? showInventory,
    bool? showSettings,
  }) {
    return AppSettings(
      appName: appName ?? this.appName,
      enableLogin: enableLogin ?? this.enableLogin,
      darkMode: darkMode ?? this.darkMode,
      followSystemTheme: followSystemTheme ?? this.followSystemTheme,
      adminUsername: adminUsername ?? this.adminUsername,
      adminPassword: adminPassword ?? this.adminPassword,
      showDashboard: showDashboard ?? this.showDashboard,
      showLocation: showLocation ?? this.showLocation,
      showOrderExpress: showOrderExpress ?? this.showOrderExpress,
      showAllRecords: showAllRecords ?? this.showAllRecords,
      showInventory: showInventory ?? this.showInventory,
      showSettings: showSettings ?? this.showSettings,
    );
  }

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'enableLogin': enableLogin,
        'darkMode': darkMode,
        'followSystemTheme': followSystemTheme,
        'adminUsername': adminUsername,
        'adminPassword': adminPassword,
        'showDashboard': showDashboard,
        'showLocation': showLocation,
        'showOrderExpress': showOrderExpress,
        'showAllRecords': showAllRecords,
        'showInventory': showInventory,
        'showSettings': showSettings,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      appName: json['appName'] ?? 'Bank and More',
      enableLogin: json['enableLogin'] ?? false,
      darkMode: json['darkMode'] ?? false,
      followSystemTheme: json['followSystemTheme'] ?? true,
      adminUsername: json['adminUsername'] ?? 'admin',
      adminPassword: json['adminPassword'] ?? '123456',
      showDashboard: json['showDashboard'] ?? true,
      showLocation: json['showLocation'] ?? true,
      showOrderExpress: json['showOrderExpress'] ?? true,
      showAllRecords: json['showAllRecords'] ?? true,
      showInventory: json['showInventory'] ?? true,
      showSettings: json['showSettings'] ?? true,
    );
  }
}
