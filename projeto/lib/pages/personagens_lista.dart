import 'package:flutter/material.dart';
import 'package:projeto/repositories/personagem.dart';

class Personagens extends StatefulWidget {
  const Personagens({super.key});
  @override
  State<Personagens> createState() => _PersonagensState();
}

class _PersonagensState extends State<Personagens> {

  List<Personagem> personagens = [
    Personagem(nome: 'guerreiro'),
    Personagem(nome: 'curandeira'),
    Personagem(nome: 'mago'),
  ];

  CheckboxListTile LI(Personagem personagem)
  {
    return CheckboxListTile(
      title: Text(personagem.nome, style: const TextStyle(
        color: Color.fromARGB(255, 165,52,121), // Defina a cor aqui também, se necessário
        fontSize: 24, // Tamanho da fonte, ajuste como preferir
      ),),
      value: personagem.checado,
      onChanged: (bool? newValue) {
        setState(() {
          personagem.checado = newValue; // Atualiza o estado do personagem específico
        });
      },
      activeColor: const Color.fromARGB(255, 45, 80, 53),
      checkColor: const Color.fromARGB(255, 165,52,121),
      tileColor: const Color.fromARGB(255, 52,165,77),
      //subtitle: Text('a morte é certa'),
    );
  }

  @override
  Widget build(BuildContext context) {



    return Column( // Use Column para empilhar widgets
      children: personagens.map((personagem) => LI(personagem)).toList(),
    );

  }
}