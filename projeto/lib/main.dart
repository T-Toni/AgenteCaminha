import 'package:flutter/material.dart';
import 'package:projeto/app.dart';
import 'package:projeto/firebase_options.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:projeto/repositories/usuarios_repository.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

//void main() {
//  runApp(const MyApp());
//}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => UsuariosRepository()),
        ChangeNotifierProvider(create: (context) => PersonagensRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

