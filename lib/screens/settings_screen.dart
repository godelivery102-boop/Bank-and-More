import 'package:flutter/material.dart';

import '../app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppSettings _settings = const AppSettings();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = LocalStorage.loadSettings();
    setState(() => _settings = settings);
  }

  Future<void> _saveSettings() async {
    await LocalStorage.saveSettings(_settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الإعدادات بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إعدادات التطبيق',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _settings.appName,
                    decoration: const InputDecoration(labelText: 'اسم التطبيق'),
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(appName: value)),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('تفعيل شاشة تسجيل الدخول'),
                    value: _settings.enableLogin,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(enableLogin: value)),
                  ),
                  SwitchListTile(
                    title: const Text('الوضع الليلي'),
                    value: _settings.darkMode,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(darkMode: value)),
                  ),
                  SwitchListTile(
                    title: const Text('استخدام نظام الجهاز'),
                    value: _settings.followSystemTheme,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(followSystemTheme: value)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _settings.adminUsername,
                    decoration: const InputDecoration(labelText: 'اسم المستخدم الإداري'),
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(adminUsername: value)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _settings.adminPassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'كلمة المرور الإداري'),
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(adminPassword: value)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إظهار الصفحات',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('لوحة التحكم'),
                    value: _settings.showDashboard,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(showDashboard: value)),
                  ),
                  SwitchListTile(
                    title: const Text('Location'),
                    value: _settings.showLocation,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(showLocation: value)),
                  ),
                  SwitchListTile(
                    title: const Text('Order Express'),
                    value: _settings.showOrderExpress,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(showOrderExpress: value)),
                  ),
                  SwitchListTile(
                    title: const Text('جميع السجلات'),
                    value: _settings.showAllRecords,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(showAllRecords: value)),
                  ),
                  SwitchListTile(
                    title: const Text('الجرد'),
                    value: _settings.showInventory,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(showInventory: value)),
                  ),
                  SwitchListTile(
                    title: const Text('الإعدادات'),
                    value: _settings.showSettings,
                    onChanged: (value) => setState(() => _settings = _settings.copyWith(showSettings: value)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
            label: const Text('حفظ الإعدادات'),
          ),
        ],
      ),
    );
  }
}
