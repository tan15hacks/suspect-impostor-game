import 'package:flutter/material.dart';

import 'app/full_game_app.dart';
import 'app/full_game_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = FullGameController(enablePersistence: true);
  await controller.loadFromStorage();
  runApp(FullSuspectGameApp(controller: controller));
}
