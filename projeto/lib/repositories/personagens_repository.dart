import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';

class PersonagensRepository extends ChangeNotifier{
  final List<Personagem>_lista = [
      Personagem(nome: 'guerreiro'),
      Personagem(nome: 'curandeira'),
      Personagem(nome: 'mago'),
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
}