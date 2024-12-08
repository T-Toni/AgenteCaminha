import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto/app.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:projeto/repositories/usuario_repository';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Garante a inicialização do Flutter
  await Firebase.initializeApp(); // Inicializa o Firebase

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsuariosRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => PersonagensRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
