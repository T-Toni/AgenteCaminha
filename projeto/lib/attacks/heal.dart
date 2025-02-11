import 'dart:math'; // Para gerar números aleatórios
import 'package:projeto/actors/allies/ally.dart'; // Classe Ally (aliado)

class Heal {
  void heal(Ally ally, Ally ally2) {

    int dano = Random().nextInt(ally.max_dano - ally.min_dano) + ally.min_dano;
    ally2.apanha(-dano);
  }
}
