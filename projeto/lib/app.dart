import 'package:flutter/material.dart';
import 'package:projeto/pages/auth_check.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 52, 22, 87), brightness: Brightness.dark),
        useMaterial3: true,

      ),
      home: AuthCheck(),
    );
  }
}
