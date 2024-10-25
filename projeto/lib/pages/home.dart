import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/pages/personagens_lista.dart';
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

  @override
  Widget build(BuildContext context) {
    personagens = context.watch<PersonagensRepository>();

    List<Personagem> personagensEscolhidos = [];

    for (Personagem personagem in personagens.lista){
      if (personagem.checado == true){
        personagensEscolhidos.add(personagem);  
      }
    }

    return gerarTextoEscolhidos(personagensEscolhidos);
  }
}