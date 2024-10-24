import 'package:flutter/material.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late PersonagensRepository escolhidos;

   @override
  Widget build(BuildContext context) {
    escolhidos = context.watch<PersonagensRepository>();

    return Text(escolhidos.toString());
  }
}