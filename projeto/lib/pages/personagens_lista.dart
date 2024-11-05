import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
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
      title: Text(personagem.nome, style: TextStyle(
        //color: colorScheme.secondary, // Defina a cor aqui também, se necessário
        fontSize: 24, // Tamanho da fonte, ajuste como preferir
      ),
    ),
    value: personagem.checado,
    onChanged: (bool? newValue) {
      personagem.checado = newValue; // Atualiza o estado do personagem específicos
      personagens.saveAll([personagem]);  // Salva os personagens escolhidos no "repositorio" de personagens escolhidos
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
      children: personagens.lista.map((personagem) => LI(personagem, colorScheme)).toList(),
    );

  }
  
}