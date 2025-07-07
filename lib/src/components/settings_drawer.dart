import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/core/token.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  Future<void> _signOut(BuildContext context) async {
    await TokenManager.deleteToken();
    await IdManager.deleteId();
    await PassManager.deletePassword();
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title:
                  const Text('Sign Out', style: TextStyle(color: Colors.red)),
              onTap: () => _signOut(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
