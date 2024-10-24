import 'package:flutter/material.dart';
import 'package:projeto/menu.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255,  135, 206, 235)),
        useMaterial3: true,

      ),
      home: const Menu(title: 'AgenteCaminha'),
      //personagens: const Personagens(title: 'Editar')
    );
  }
}
