import 'package:flutter/material.dart';
import 'package:reactiontest/main_page/body.dart';
import 'package:reactiontest/settings_page/settings_view.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: const Body(),
    );
  }
}
