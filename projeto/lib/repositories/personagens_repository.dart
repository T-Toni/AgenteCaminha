import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';

class PersonagensRepository extends ChangeNotifier{
  final List<Personagem>_lista = [
      Personagem(nome: 'Guerreiro', imagem: 'assets/bola2.png', posicao: 0),
      Personagem(nome: 'Curandeira', imagem: 'assets/bola1.png', posicao: 1),
      Personagem(nome: 'Mago', imagem: 'assets/mago.png', posicao: 2),
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

  move(Personagem personagem, int posicao){
    personagem.posicao = posicao;
    notifyListeners();
  }
}