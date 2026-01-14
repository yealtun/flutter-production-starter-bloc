import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/config/env.dart';

/// Settings screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, bool> _featureFlags = {
    'enable_ai_demo': true,
    'enable_sdk_demo': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Environment'),
            subtitle: Text(Env.appEnv.toUpperCase()),
            leading: const Icon(Icons.settings),
          ),
          const Divider(),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.hasData
                  ? '${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                  : 'Loading...';
              return ListTile(
                title: const Text('App Version'),
                subtitle: Text(version),
                leading: const Icon(Icons.info),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Feature Flags',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ..._featureFlags.entries.map(
            (entry) => SwitchListTile(
              title: Text(entry.key),
              value: entry.value,
              onChanged: (value) {
                setState(() {
                  _featureFlags[entry.key] = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
