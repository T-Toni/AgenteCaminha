import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:projeto/repositories/user_info_repository.dart';
import 'package:provider/provider.dart';

class TelaRecompensas extends StatefulWidget {
  final double kmcaminhados;
  
  const TelaRecompensas(this.kmcaminhados, {super.key});

  @override
  State<TelaRecompensas> createState() => _TelaRecompensasState();
}

class _TelaRecompensasState extends State<TelaRecompensas> {

  late UserInfoRepository userInfo;
  late PersonagensRepository personagens;
  
  List<Recompensa> recompensasPossiveis = [];

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
    final colorScheme = Theme.of(context).colorScheme;

    userInfo = context.watch<UserInfoRepository>();
    personagens = context.watch<PersonagensRepository>();

    if (widget.kmcaminhados < 0.5){
      recompensasPossiveis.addAll([
        Recompensa(nome: 'Infelizmente não foi encontrado nada durante a caminhada. Tente caminhar por um trajeto mais longo da próxima vez!', imagem: 'assets/images/triste.png', chance: 100),
      ]);
    }
    else if ((widget.kmcaminhados < 1)){
      if (personagens.lista.isEmpty){
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Infelizmente não foi encontrado nada durante a caminhada. Tente caminhar por um trajeto mais longo da próxima vez!', imagem: 'assets/images/triste.png', chance: 50),
          Recompensa(nome: 'Durante sua caminhada foi encontrado 1 ponto pelo caminho. Vá utliza-lo na aba de personagens!', imagem: 'assets/images/+1.png', chance: 50, levelup: 1),
        ]);
      }
      else{
        Personagem personagem = personagens.getPersonagemRandomNaoObtido();
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Infelizmente não foi encontrado nada durante a caminhada. Tente caminhar por um trajeto mais longo da próxima vez!', imagem: 'assets/images/triste.png', chance: 45),
          Recompensa(nome: 'Durante sua caminhada foi encontrado 1 ponto pelo caminho. Vá utliza-lo na aba de personagens!', imagem: 'assets/images/+1.png', chance: 50, levelup: 1),
          Recompensa(nome: 'Durante sua caminhada foi encontrado um personagem novo!!!', imagem: personagem.imagem, chance: 5, personagem: personagem),
        ]);
      }
    }
    else if (widget.kmcaminhados < 2) {
      if (personagens.lista.isEmpty){
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Durante sua caminhada foi encontrado 1 ponto pelo caminho. Vá utilizá-lo na aba de personagens!', imagem: 'assets/images/+1.png', chance: 50, levelup: 1),
          Recompensa(nome: 'Durante sua caminhada foi encontrado 2 pontos pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+2.png', chance: 50, levelup: 2),
        ]);
      }
      else{
        Personagem personagem = personagens.getPersonagemRandomNaoObtido();
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Durante sua caminhada foi encontrado 1 ponto pelo caminho. Vá utilizá-lo na aba de personagens!', imagem: 'assets/images/+1.png', chance: 40, levelup: 1),
          Recompensa(nome: 'Durante sua caminhada foram encontrados 2 pontos pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+2.png', chance: 50, levelup: 2),
          Recompensa(nome: 'Durante sua caminhada foi encontrado um personagem novo!!!', imagem: personagem.imagem, chance: 10, personagem: personagem),
        ]);
      }
    } else if (widget.kmcaminhados < 3) {
      if (personagens.lista.isEmpty){
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Durante sua caminhada foi encontrado 1 ponto pelo caminho. Vá utilizá-lo na aba de personagens!', imagem: 'assets/images/+1.png', chance: 30, levelup: 1),
          Recompensa(nome: 'Durante sua caminhada foram encontrados 2 ponto pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+2.png', chance: 40, levelup: 2),
          Recompensa(nome: 'Durante sua caminhada foram encontrados 3 pontos pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+3.png', chance: 30, levelup: 3),
        ]);
      }
      else{
        Personagem personagem = personagens.getPersonagemRandomNaoObtido();
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Durante sua caminhada foi encontrado 1 ponto pelo caminho. Vá utilizá-lo na aba de personagens!', imagem: 'assets/images/+1.png', chance: 15, levelup: 1),
          Recompensa(nome: 'Durante sua caminhada foram encontrados 2 ponto pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+2.png', chance: 40, levelup: 2),
          Recompensa(nome: 'Durante sua caminhada foram encontrados 3 pontos pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+3.png', chance: 30, levelup: 3),
          Recompensa(nome: 'Durante sua caminhada foi encontrado um personagem novo!!!', imagem: personagem.imagem, chance: 15, personagem: personagem),
        ]);
      }
    } else {
      if (personagens.lista.isEmpty){
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Durante sua caminhada foram encontrados 2 ponto pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+2.png', chance: 40, levelup: 2),
          Recompensa(nome: 'Durante sua caminhada foram encontrados 3 pontos pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+3.png', chance: 60, levelup: 3),
        ]);
      }
      else{
        Personagem personagem = personagens.getPersonagemRandomNaoObtido();
        recompensasPossiveis.addAll([
          Recompensa(nome: 'Durante sua caminhada foram encontrados 2 ponto pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+2.png', chance: 10, levelup: 2),
          Recompensa(nome: 'Durante sua caminhada foram encontrados 3 pontos pelo caminho. Vá utilizá-los na aba de personagens!', imagem: 'assets/images/+3.png', chance: 60, levelup: 3),
          Recompensa(nome: 'Durante sua caminhada foi encontrado um personagem novo!!!', imagem: personagem.imagem, chance: 30, personagem: personagem),
        ]);
      }
    }
    Recompensa? recompensaAtual = sortear(recompensasPossiveis);

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
                        'Caminhada de ${widget.kmcaminhados.toStringAsFixed(1)} km',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      recompensaAtual.nome,
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
                        recompensaAtual.darRecompensa(userInfo, personagens);
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

  int levelup;
  Personagem? personagem;

  Recompensa({
    required this.nome,
    required this.imagem,
    required this.chance,
    
    this.levelup = 0,
    this.personagem,
  });

  void darRecompensa(UserInfoRepository userInfo, PersonagensRepository personagens){
    if (levelup != 0){
      userInfo.adicionarPontos(levelup);
    }
    else if (personagem != null){
      personagens.obterPersonagem(personagem!.id);
    }
  }
}