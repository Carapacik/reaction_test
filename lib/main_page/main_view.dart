import 'package:flutter/material.dart';
import 'package:reactiontest/main_page/body.dart';
import 'package:reactiontest/settings_page/settings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  static const routeName = '/';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async => Navigator.of(context).pushNamed(SettingsView.routeName),
        ),
      ],
    ),
    body: const Body(),
  );
}
