import 'dart:math';
import 'package:projeto/attacks/attack.dart';
import 'package:projeto/game/combate_game.dart';
import 'package:projeto/world/parede.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:projeto/actors/enemies/enemy.dart';
import 'package:flutter/material.dart';

class Ally extends SpriteComponent with CollisionCallbacks, HasGameRef<Combategame> {
  Vector2 direction;
  Vector2 knockbackVelocity = Vector2.zero();
  double knockbackDecay = 0.9;
  bool sendoEmpurrado = false;
  bool colidiu = false;
  bool c_dir = false;
  bool c_esq = false;
  bool c_cima = false;
  bool c_baixo = false;

  double speed;
  int min_dano;
  int max_dano;
  int min_acerto;
  int max_acerto;
  int vida;

  bool lutando = false;
  double tempoDeLuta = 2;
  double valor_tempoDeLuta = 2;

  late Enemy adversario;

  late TextComponent vidaText;
  late TextComponent lutandoText;

  Ally({
    required this.speed,
    required this.direction,
    required this.min_dano,
    required this.max_dano,
    required this.vida,
    required this.min_acerto,
    required this.max_acerto,
  }) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox()..collisionType = CollisionType.active);

    vidaText = TextComponent(
      text: '$vida',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      anchor: Anchor.bottomCenter,
      position: Vector2(size.x / 2, 10),
    );

    lutandoText = TextComponent(
      text: 'lutando: $lutando',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      anchor: Anchor.bottomCenter,
      position: Vector2(size.x / 2, 15),
    );

    add(vidaText);
  }

  @override
  void onMount() {
    super.onMount();
    // Agora o componente está montado e pode acessar gameRef
    escolherNovoCaminho();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);

    if (other is Parede || other is Enemy) {
      final intersection_f = intersectionPoints.first;
      final intersection_l = intersectionPoints.last;

      if (intersection_l.x == intersection_f.x) {
        if (intersection_f.x > absoluteCenter.x) c_dir = true;
        if (intersection_f.x < absoluteCenter.x) c_esq = true;
      } else if (intersection_l.y == intersection_f.y) {
        if (intersection_f.y < absoluteCenter.y) c_cima = true;
        if (intersection_f.y > absoluteCenter.y) c_baixo = true;
      }
    }

    if (other is Enemy && !lutando) {
      lutando = true;
      other.lutando = true;
      adversario = other;
    }
  }

  @override
  void update(double dt) {
    // Atualiza a vida
    if (!isLoaded) return;

    if (lutando) {
      vidaText.text = '$vida ⚔️';
    } else {
      vidaText.text = '$vida';
    }
    vidaText.position = Vector2(size.x / 2, this.width / 10);

    if (!lutando) {
      Vector2 displacement = direction - position;
      double distance = displacement.length;

      colidiu = c_dir || c_esq || c_cima || c_baixo;

      if (distance > 0) {
        Vector2 normalizedDirection = displacement / distance;
        double maxStep = speed * dt;
        if (maxStep > distance) maxStep = distance;

        // Confere as colisões com a parede
        if (c_dir && normalizedDirection.x > 0) normalizedDirection.x = 0;
        if (c_esq && normalizedDirection.x < 0) normalizedDirection.x = 0;
        if (c_baixo && normalizedDirection.y > 0) normalizedDirection.y = 0;
        if (c_cima && normalizedDirection.y < 0) normalizedDirection.y = 0;

        c_dir = c_esq = c_baixo = c_cima = false;
        position += normalizedDirection * maxStep;

        if (colidiu) {
          escolherNovoCaminho();
        }
      } else {
        escolherNovoCaminho();
      }
    } else {
      // Fica parado por um tempo e depois executa o ataque
      tempoDeLuta -= dt;
      if (tempoDeLuta <= 0) {
        Ataque ataque = Ataque();
        ataque.ataque(this, adversario);
        tempoDeLuta = valor_tempoDeLuta;
      }

      if (sendoEmpurrado) {
        // Executa o knockback
        if (c_dir && knockbackVelocity.x > 0) knockbackVelocity.x = 0;
        if (c_esq && knockbackVelocity.x < 0) knockbackVelocity.x = 0;
        if (c_baixo && knockbackVelocity.y > 0) knockbackVelocity.y = 0;
        if (c_cima && knockbackVelocity.y < 0) knockbackVelocity.y = 0;

        position += knockbackVelocity * dt;
        knockbackVelocity *= knockbackDecay;
        if (knockbackVelocity.length < 0.1) {
          sendoEmpurrado = false;
          lutando = false;
        }
      }
    }
  }

  void knockback(Vector2 collisionNormal, double force) {
    knockbackVelocity = collisionNormal.normalized() * force;
    sendoEmpurrado = true;
  }

  void escolherNovoCaminho() {
    direction = Vector2(
      Random().nextDouble() * gameRef.size.x,
      Random().nextDouble() * gameRef.size.y,
    );
  }

  void apanha(int dano) {
    print("Ally tomou $dano de dano. Vida antes: $vida");

    vida -= dano;
    if (vida <= 0) {
      vida = 0;
      print("Ally morreu!");
      removeFromParent(); // Remove o aliado do jogo
    }

    print("Vida depois: $vida");
  }
}
