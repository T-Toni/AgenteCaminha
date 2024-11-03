import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late PersonagensRepository personagens;
  
  List<int> estadosGrid = List<int>.filled(15, 0);
  
  Personagem? marcado;

  List<Personagem> personagensEscolhidos = [];

  void marcarPersonagem(Personagem personagem, int index) {
    setState(() {
      estadosGrid[index] = (estadosGrid[index] + 1) % 2; // Alterna entre 0 e 1
    });
    marcado = personagem;
  }

  void trocarPosicao(int index){
    if (marcado != null){
      Personagem? personagemTroca = getPersonagemNaPosicao(index, personagensEscolhidos);
      if (personagemTroca != null){
        personagens.move(personagemTroca, marcado!.posicao);
      }
    personagens.move(marcado!, index);
    marcado = null;
    estadosGrid.fillRange(0, 15, 0);
    }
  }

  Personagem? getPersonagemNaPosicao(int posicao, List lista) {
    final personagem = lista.where((p) => p.posicao == posicao);
    return personagem.isNotEmpty ? personagem.first : null;
  }

  @override
  Widget build(BuildContext context) {
    personagens = context.watch<PersonagensRepository>();

    for (Personagem personagem in personagens.lista){
      if (personagem.checado == true){
        personagensEscolhidos.add(personagem);
      }
    }
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end, // Posiciona a grid no final da tela
      children: [
        Container(
          height: 250, // Altura da grid 3 linhas
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(0, 224, 224, 224),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // Desativa o scroll
            itemCount: 15, // 5x3 = 15 blocos
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 5 colunas de lado a lado
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              final personagemDisplay = getPersonagemNaPosicao(index, personagensEscolhidos);
              return GestureDetector(
                onTap: () => (personagemDisplay != null && marcado == null)
                          ? marcarPersonagem(personagemDisplay, index)
                          : trocarPosicao(index), // Altera o estado ao clicar
                child: Container(
                  decoration: BoxDecoration(
                    color: estadosGrid[index] == 0 ? Colors.white : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                    image: personagemDisplay != null
                          ? DecorationImage(
                              image: AssetImage(personagemDisplay.imagem),
                              fit: BoxFit.cover,
                            )
                          : null, // Aplica a imagem do personagem, se houver
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}