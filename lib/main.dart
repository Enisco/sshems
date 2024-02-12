import 'package:flutter/material.dart';
import 'package:sshems/firebase_options.dart';
import 'package:sshems/sshems_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SshemsApp());
}
