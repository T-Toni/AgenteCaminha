import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:provider/provider.dart';

class TelaRecompensas extends StatefulWidget {
  const TelaRecompensas(double kmcaminhados, {super.key});

  @override
  State<TelaRecompensas> createState() => _TelaRecompensasState();
}

class _TelaRecompensasState extends State<TelaRecompensas> {

  late PersonagensRepository personagens;
  
  List<Recompensa> recompensasPossiveis = [
    Recompensa(nome: '+3 níveis a todos os personagens do seu time atual', imagem: 'assets/images/+3.png', chance: 10, levelup: 3),
    Recompensa(nome: '+2 níveis a todos os personagens do seu time atual', imagem: 'assets/images/+2.png', chance: 30, levelup: 2),
    Recompensa(nome: '+1 nível a todos os personagens do seu time atual', imagem: 'assets/images/+1.png', chance: 60, levelup: 1),
  ];

  Recompensa? sortear(List<Recompensa> recompensas) {
    
    final Random random = Random();
    
    // Calcula o total das chances
    double totalChance = recompensas.fold(0, (sum, item) => sum + item.chance);

    // Sorteia um número entre 0 e totalChance
    double sorteio = random.nextDouble() * totalChance;

    // Percorre as recompensas para determinar o item sorteado
    double acumulado = 0;
    for (var recompensa in recompensas) {
      acumulado += recompensa.chance;
      if (sorteio <= acumulado) {
        return recompensa;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    
    Recompensa? recompensaAtual = sortear(recompensasPossiveis);

    final colorScheme = Theme.of(context).colorScheme;

    personagens = context.watch<PersonagensRepository>();

    recompensaAtual?.darRecompensa(personagens.listaObtidos);

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
                  recompensaAtual!.imagem,
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
                      'Parabéns!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Você ganhou ${recompensaAtual.nome}!',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
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
  double chance; // 0 a 100

  int levelup = 0;

  Recompensa({
    required this.nome,
    required this.imagem,
    required this.chance,
    this.levelup = 0,
  });

  void darRecompensa(UnmodifiableListView<Personagem> personagens){
    if (levelup != 0){
      for (var personagem in personagens){
        if (personagem.checado == true){
          personagem.nivel += levelup;
        }
      }
    }
  }
}