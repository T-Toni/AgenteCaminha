import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projeto/repositories/user_info_repository.dart';
import 'package:provider/provider.dart';

class TelaRecompensas extends StatefulWidget {
  const TelaRecompensas(double kmcaminhados, {super.key});

  @override
  State<TelaRecompensas> createState() => _TelaRecompensasState();
}

class _TelaRecompensasState extends State<TelaRecompensas> {

  late UserInfoRepository userInfo;
  
  List<Recompensa> recompensasPossiveis = [
    Recompensa(nome: '+3 pontos!!!', imagem: 'assets/images/+3.png', chance: 10, levelup: 3),
    Recompensa(nome: '+2 pontos!', imagem: 'assets/images/+2.png', chance: 30, levelup: 2),
    Recompensa(nome: '+1 ponto', imagem: 'assets/images/+1.png', chance: 60, levelup: 1),
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

    userInfo = context.watch<UserInfoRepository>();

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
                      'Você ganhou ${recompensaAtual.nome}! Agora você pode distribuir do jeito que voce quiser entre seus personagens na aba de "Personagens"',
                      style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      ),
                      textAlign: TextAlign.center, // Centraliza o texto
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, 1);
                        recompensaAtual.darRecompensa(userInfo);
                      },
                      child: Text('Coletar recompensas'),
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
    required this.levelup,
  });

  void darRecompensa(UserInfoRepository userInfo){
    userInfo.adicionarPontos(levelup);
  }
}