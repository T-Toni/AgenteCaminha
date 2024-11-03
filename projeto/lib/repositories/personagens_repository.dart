import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';

class PersonagensRepository extends ChangeNotifier{
  final List<Personagem>_lista = [
<<<<<<< Updated upstream
      Personagem(nome: 'guerreiro', imagem: 'assets/bola1.png'),
      Personagem(nome: 'curandeira', imagem: 'assets/bola2.png'),
      Personagem(nome: 'mago', imagem: 'assets/mago.png'),
=======
      Personagem(nome: 'guerreiro', imagem: 'assets/bola2.png', posicao: 0),
      Personagem(nome: 'curandeira', imagem: 'assets/bola1.png', posicao: 1),
      Personagem(nome: 'mago', imagem: 'assets/mago.png', posicao: 2),
>>>>>>> Stashed changes
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