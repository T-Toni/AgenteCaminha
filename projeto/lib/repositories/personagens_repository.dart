import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';

class PersonagensRepository extends ChangeNotifier{
  List<Personagem>_lista = [
      Personagem(nome: 'guerreiro'),
      Personagem(nome: 'curandeira'),
      Personagem(nome: 'mago'),
    ];

  UnmodifiableListView<Personagem> get lista => UnmodifiableListView(_lista);

  saveAll(List<Personagem> personagens){
    personagens.forEach((personagem){
      if (!_lista.contains(personagem)) _lista.add(personagem);
    });
    notifyListeners();
  }

  remove(Personagem personagem){
    _lista.remove(personagem);
    notifyListeners();
  }
}