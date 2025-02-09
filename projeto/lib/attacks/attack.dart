import 'dart:math'; // Para gerar números aleatórios
import 'package:flame/components.dart'; // Para manipular vetores e componentes do Flame
import 'package:flame/game.dart'; // Para acessar a referência do jogo
import 'package:projeto/actors/allies/ally.dart'; // Classe Ally (aliado)
import 'package:projeto/actors/enemies/enemy.dart'; // Classe Enemy (inimigo)

class Ataque {
  // Duração total do ataque (ou use animation.done() para remover ao fim da animação)

  void ataque(Ally ally, Enemy enemy) {
    int ally_decision =
        Random().nextInt(ally.max_acerto - ally.min_acerto) + ally.min_acerto;
    int enemy_decision = Random().nextInt(enemy.max_acerto - enemy.min_acerto) +
        enemy.min_acerto;

    // Calcula a direção entre os dois personagens
    Vector2 knockbackDirection = (enemy.position - ally.position).normalized();

    if (enemy_decision >= ally_decision) {

      // Aliado ataca
      int dano =
          Random().nextInt(ally.max_dano - ally.min_dano) + ally.min_dano;
      enemy.apanha(dano);

      // Inimigo recebe knockback na direção oposta ao Ally
      enemy.knockback(knockbackDirection, 350);

      // Aliado também recebe um pequeno knockback na direção contrária
      ally.knockback(-knockbackDirection, 150);

    } else {  // Inimigo ataca

      int dano =
          Random().nextInt(enemy.max_dano - enemy.min_dano) + enemy.min_dano;
      ally.apanha(dano);

      // Aliado recebe knockback
      ally.knockback(-knockbackDirection, 150);

      // Inimigo recebe knockback na direção oposta
      enemy.knockback(knockbackDirection, 350);

    }
  }
}
