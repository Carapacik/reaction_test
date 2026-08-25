import 'package:material_ui/material_ui.dart';
import 'package:reactiontest/src/reaction_test/reaction_test_body.dart';
import 'package:reactiontest/src/settings_page/settings_view.dart';

class const ReactionTestView({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [
        IconButton(
          tooltip: 'Appearance',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.of(context).pushNamed(SettingsView.routeName),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: const SafeArea(child: ReactionTestBody()),
  );
}
