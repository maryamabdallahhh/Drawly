import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vivid_canvas/features/canvas/presentation/screens/whiteboard_screen.dart';
import 'package:vivid_canvas/firebase_options.dart';
import 'package:vivid_canvas/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: Drawly()));
}

class Drawly extends StatelessWidget {
  const Drawly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawly',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const WhiteboardScreen(),
    );
  }
}
