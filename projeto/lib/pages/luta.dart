import 'package:flutter/material.dart';

class Luta extends StatefulWidget {
  const Luta({super.key, required this.title});

  final String title;

  @override
  State<Luta> createState() => _LutaState();
}

class _LutaState extends State<Luta> {

   @override
  Widget build(BuildContext context) {

    return const Text('lutas');
  }
}