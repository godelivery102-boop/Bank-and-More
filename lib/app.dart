import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/app_settings.dart';
import 'models/location_record.dart';
import 'models/order_express_record.dart';
import 'models/inventory_item.dart';
import 'screens/all_records_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/location_screen.dart';
import 'screens/order_express_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';

class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError('LocalStorage not initialized. Call LocalStorage.init() first.');
    }
    return _prefs!;
  }

  static Future<void> saveSettings(AppSettings settings) async {
    await _instance.setString('app_settings', jsonEncode(settings.toJson()));
  }

  static AppSettings loadSettings() {
    final raw = _instance.getString('app_settings');
    if (raw == null || raw.isEmpty) {
      return const AppSettings();
    }

    try {
      return AppSettings.fromJson(jsonDecode(raw));
    } catch (_) {
      return const AppSettings();
    }
  }

  static Future<void> saveLocationRecords(List<LocationRecord> records) async {
    final values = records.map((record) => jsonEncode(record.toJson())).toList();
    await _instance.setStringList('location_records', values);
  }

  static List<LocationRecord> loadLocationRecords() {
    final values = _instance.getStringList('location_records') ?? const <String>[];
    return values
        .map((element) => LocationRecord.fromJson(jsonDecode(element)))
        .toList();
  }

  static Future<void> saveOrderRecords(List<OrderExpressRecord> records) async {
    final values = records.map((record) => jsonEncode(record.toJson())).toList();
    await _instance.setStringList('order_records', values);
  }

  static List<OrderExpressRecord> loadOrderRecords() {
    final values = _instance.getStringList('order_records') ?? const <String>[];
    return values
        .map((element) => OrderExpressRecord.fromJson(jsonDecode(element)))
        .toList();
  }

  static Future<void> saveInventoryItems(List<InventoryItem> items) async {
    final values = items.map((item) => jsonEncode(item.toJson())).toList();
    await _instance.setStringList('inventory_items', values);
  }

  static List<InventoryItem> loadInventoryItems() {
    final values = _instance.getStringList('inventory_items') ?? const <String>[];
    return values
        .map((element) => InventoryItem.fromJson(jsonDecode(element)))
        .toList();
  }
}

class BankAndMoreApp extends StatefulWidget {
  const BankAndMoreApp({super.key});

  @override
  State<BankAndMoreApp> createState() => _BankAndMoreAppState();
}

class _BankAndMoreAppState extends State<BankAndMoreApp> {
  AppSettings _settings = const AppSettings();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final loaded = LocalStorage.loadSettings();
    setState(() {
      _settings = loaded;
      _isLoggedIn = !loaded.enableLogin;
    });
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = _settings.followSystemTheme
        ? ThemeMode.system
        : (_settings.darkMode ? ThemeMode.dark : ThemeMode.light);

    return MaterialApp(
      title: _settings.appName,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101827),
      ),
      home: _settings.enableLogin && !_isLoggedIn
          ? LoginScreen(
              settings: _settings,
              onLoginSuccess: _handleLogin,
            )
          : HomeShell(settings: _settings),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      if (widget.settings.showDashboard) const DashboardScreen(),
      if (widget.settings.showLocation) const LocationScreen(),
      if (widget.settings.showOrderExpress) const OrderExpressScreen(),
      if (widget.settings.showAllRecords) const AllRecordsScreen(),
      if (widget.settings.showInventory) const InventoryScreen(),
      if (widget.settings.showSettings) const SettingsScreen(),
    ];

    final destinations = <NavigationDestination>[
      if (widget.settings.showDashboard)
        const NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'لوحة التحكم'),
      if (widget.settings.showLocation)
        const NavigationDestination(icon: Icon(Icons.location_on_outlined), label: 'Location'),
      if (widget.settings.showOrderExpress)
        const NavigationDestination(icon: Icon(Icons.local_shipping_outlined), label: 'Order Express'),
      if (widget.settings.showAllRecords)
        const NavigationDestination(icon: Icon(Icons.list_alt_outlined), label: 'جميع السجلات'),
      if (widget.settings.showInventory)
        const NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'الجرد'),
      if (widget.settings.showSettings)
        const NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'الإعدادات'),
    ];

    if (_index >= pages.length) {
      _index = 0;
    }

    return Scaffold(
      body: pages.isEmpty ? const Center(child: Text('لا توجد صفحات مفعلة')) : pages[_index],
      bottomNavigationBar: pages.length > 1
          ? NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) {
                setState(() {
                  _index = value;
                });
              },
              destinations: destinations,
            )
          : null,
    );
  }
}
