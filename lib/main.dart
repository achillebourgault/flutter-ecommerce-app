import 'package:ecommerce_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Assure-toi que ce fichier est correctement importé

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // S'assurer que les bindings sont initialisés
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Utiliser les options par défaut pour la plateforme actuelle
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
