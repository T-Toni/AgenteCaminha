import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';

class PersonagensRepository extends ChangeNotifier{
  final List<Personagem>_lista = [
      Personagem(nome: 'guerreiro', imagem: 'assets/bola1.png', posicao:0),
      Personagem(nome: 'curandeira', imagem: 'assets/bola2.png', posicao:1),
      Personagem(nome: 'mago', imagem: 'assets/mago.png', posicao:2),
    ];

  UnmodifiableListView<Personagem> get lista => UnmodifiableListView(_lista);

  saveAll(List<Personagem> personagens){
    for (var personagem in personagens) {
      if (!_lista.contains(personagem)) _lista.add(personagem);
    }
    notifyListeners();
  }

  remove(Personagem personagem){
    _lista.remove(personagem);
    notifyListeners();
  }

  Personagem? getPersonagemNaPosicao(int posicao) {
    final personagem = _lista.where((p) => p.posicao == posicao);
    return personagem.isNotEmpty ? personagem.first : null;
  }

  changePosition(int posicao1, int posicao2){
    final personagem1 = getPersonagemNaPosicao(posicao1);
    final personagem2 = getPersonagemNaPosicao(posicao2);
    
    personagem1?.posicao = posicao2;
    personagem2?.posicao = posicao1;

    notifyListeners();
  }

}