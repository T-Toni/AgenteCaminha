import 'dart:math';
import 'package:flutter/material.dart';

class TelaRecompensas extends StatefulWidget {
  const TelaRecompensas({super.key});

  @override
  State<TelaRecompensas> createState() => _TelaRecompensasState();
}

class _TelaRecompensasState extends State<TelaRecompensas> {

  List<Recompensa> recompensasPossiveis = [
    Recompensa(nome: '1 nível a todos os personagens do seu time', imagem: 'assets/images/mago.png'),
    Recompensa(nome: '2 níveis a todos os personagens do seu time', imagem: 'assets/images/mago.png'),
    Recompensa(nome: '3 níveis a todos os personagens do seu time', imagem: 'assets/images/mago.png'),
  ];

  @override
  Widget build(BuildContext context) {
    
    int numeroAleatorio = Random().nextInt(recompensasPossiveis.length);
    Recompensa recompensaAtual = recompensasPossiveis[numeroAleatorio];

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Recompensa'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Container(
        color: colorScheme.inversePrimary, // Fundo no mesmo esquema de cores
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  recompensaAtual.imagem,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      recompensaAtual.nome,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Recompensa {
  
  String nome;
  String imagem;


  Recompensa({
    required this.nome,
    required this.imagem,
  });
}