import 'package:flutter/material.dart';
//import 'package:projeto/menu.dart';
import 'package:projeto/pages/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 52, 22, 87),
            brightness: Brightness.dark),
        useMaterial3: true,
      ),
      //home: const Menu(title: 'AgenteCaminha'),
      home: LoginScreen(),
      //personagens: const Personagens(title: 'Editar')
    );
  }
}
