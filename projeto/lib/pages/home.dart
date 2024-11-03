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

  Text gerarTextoEscolhidos(List<Personagem> personagensEscolhidos){
    List<String> nomes = [];
    for (Personagem personagem in personagensEscolhidos){
      nomes.add(personagem.nome);
    }
    return Text(nomes.toString());
  }

  ListTile gerarTile(Personagem personagem){
    return ListTile(
      leading: Image(image: AssetImage(personagem.imagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    personagens = context.watch<PersonagensRepository>();

    List<Personagem> personagensEscolhidos = [];

    for (Personagem personagem in personagens.lista){
      if (personagem.checado == true){
        personagensEscolhidos.add(personagem);
      }
    }
    
<<<<<<< Updated upstream
    return Column( // Use Column para empilhar widgets
      children: personagensEscolhidos.map((personagem) => gerarTile(personagem)).toList(),
=======
    return Column(
      mainAxisAlignment: MainAxisAlignment.end, // Posiciona a grid no final da tela
      children: [
        Container(
          height: 250, // Altura da grid 3 linhas
          padding: const EdgeInsets.all(8.0),
          //color: const Color.fromARGB(0, 224, 224, 224),
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
                    //color: estadosGrid[index] == 0 ? const Color.fromARGB(122, 127, 56, 185) : Colors.blueAccent,
                    color: Theme.of(context).colorScheme.primary,
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
>>>>>>> Stashed changes
    );
    //return gerarTextoEscolhidos(personagensEscolhidos);
  }
}