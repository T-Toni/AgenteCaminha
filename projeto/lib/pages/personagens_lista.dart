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


  CheckboxListTile LI(Personagem personagem)
  {
    return CheckboxListTile(
      title: Text(personagem.nome, style: const TextStyle(
        color: Color.fromARGB(255, 44, 61, 77), // Defina a cor aqui também, se necessário
        fontSize: 24, // Tamanho da fonte, ajuste como preferir
      ),
    ),
    value: personagem.checado,
    onChanged: (bool? newValue) {
      personagem.checado = newValue; // Atualiza o estado do personagem específicos
      personagens.saveAll([personagem]);  //salva os personagens escolhidos no "repositorio" de personagens escolhidos
    },
    activeColor: const Color.fromARGB(255, 44, 61, 77),
    checkColor: const Color.fromARGB(255, 215, 226, 255),
    tileColor: const Color.fromARGB(255, 215, 226, 255),
    //subtitle: Text('a morte é certa'),
    );
  }

  @override
  Widget build(BuildContext context) {

    personagens = context.watch<PersonagensRepository>();
    
    return Column( // Use Column para empilhar widgets
      children: personagens.lista.map((personagem) => LI(personagem)).toList(),
    );

  }
  
}