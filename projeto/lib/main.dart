import 'package:flutter/material.dart';
import 'package:projeto/app.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:projeto/repositories/usuarios_repository.dart';
import 'package:provider/provider.dart';

//void main() {
//  runApp(const MyApp());
//}

void main() {
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


