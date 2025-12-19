import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/white_board_screen.dart';
import 'package:vivid_canvas/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: VividCanvasApp()));
}

class VividCanvasApp extends StatelessWidget {
  const VividCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WhiteboardScreen());
  }
}
