import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/pages/detalhes_personagem.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:projeto/repositories/user_info_repository.dart';
import 'package:provider/provider.dart';

class Personagens extends StatefulWidget {
  const Personagens({super.key});
  @override
  State<Personagens> createState() => _PersonagensState();
}

class _PersonagensState extends State<Personagens> {

  late PersonagensRepository personagens;
  late UserInfoRepository userInfo;

  CheckboxListTile LI(Personagem personagem, ColorScheme colorScheme)
  {
    return CheckboxListTile(
      title: Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          personagem.imagem,
          height: 35,
          width: 35,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 10),
        Text(
          personagem.nome,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        SizedBox(width: 10),
        Text(
          "lvl ${personagem.nivel}",
          style: TextStyle(
            fontSize: 20,
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
    userInfo = context.watch<UserInfoRepository>();

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
      children: [
        if(userInfo.qntPontos > 0)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '(${userInfo.qntPontos} pontos restantes)',
            style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: personagens.listaObtidos
              .map((personagem) => LI(personagem, colorScheme))
              .toList(),
          ),
        ),
      ],
      ),
      backgroundColor: colorScheme.inversePrimary,
    );

  }
  
}