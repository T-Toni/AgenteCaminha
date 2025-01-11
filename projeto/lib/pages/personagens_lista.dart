import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/pages/detalhes_personagem.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:provider/provider.dart';

class Personagens extends StatefulWidget {
  const Personagens({super.key});
  @override
  State<Personagens> createState() => _PersonagensState();
}

class _PersonagensState extends State<Personagens> {

  late PersonagensRepository personagens;


  CheckboxListTile LI(Personagem personagem, ColorScheme colorScheme)
  {
    return CheckboxListTile(
      title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          personagem.nome,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        IconButton(
          icon: Icon(Icons.info, color: colorScheme.primary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalhesPersonagemScreen(
                  personagem: personagem,
                ),
              ),
            ).then((result) {
              personagens.salvarPersonagemNoFirebase([personagem]);
            });
          },
        ),
      ],
    ),
      value: personagem.checado,
      onChanged: (bool? newValue) {
        personagem.checado = newValue!; // Atualiza o estado do personagem específicos
        personagens.saveAll([personagem]);  // Salva os personagens escolhidos no "repositorio" de personagens escolhidos
        personagens.salvarPersonagemNoFirebase([personagem]);

        // TESTE ADICIONAR O PERSONAGEM NOVO A LISTA DE OBTIDOS
        //var value = 4;
        //personagens.obterPersonagem('$value');

      },
      //activeColor: colorScheme.primary,
      //checkColor: colorScheme.primary,
      //tileColor: colorScheme.primary,
      //subtitle: Text(''),
    );
  }

  @override
  Widget build(BuildContext context) {

    personagens = context.watch<PersonagensRepository>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column( // Use Column para empilhar widgets
      children: personagens.listaObtidos.map((personagem) => LI(personagem, colorScheme)).toList(),
    );

  }
  
}