import 'dart:math';
import 'package:projeto/actors/allies/ally.dart';
import 'package:projeto/game/combate_game.dart';
import 'package:projeto/world/parede.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Enemy extends SpriteComponent
  with CollisionCallbacks, HasGameRef<Combategame> {
  double speed;
  Vector2 direction;
  Vector2 knockbackVelocity = Vector2.zero();
  double knockbackDecay = 0.9;
  bool sendoEmpurrado = false;
  bool pausado = false;
  double pauseTimer = 0.0;

  bool colidiu = false;
  bool c_dir = false;
  bool c_esq = false;
  bool c_cima = false;
  bool c_baixo = false;

  int min_dano;
  int max_dano;
  int min_acerto;
  int max_acerto;
  int vida;

  bool lutando = false;
  //bool pausado = false;

  double tempoDeLuta = 2;
  double valor_tempoDeLuta = 2;

  late Ally adversario;

  late TextComponent vidaText;
  late TextComponent lutandoText;

  Enemy({
    required this.speed,
    required this.direction,
    required this.min_dano,
    required this.max_dano,
    required this.vida,
    required this.min_acerto,
    required this.max_acerto,
  }) : super() {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());

    vidaText = TextComponent(
      text: '$vida',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      anchor: Anchor.bottomCenter,
      position: Vector2(size.x / 2, -10),
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
      position: Vector2(size.x / 2, -20),
    );

    add(vidaText);
    //add(lutandoText);
  }

  @override
  void update(double dt) {


    super.update(dt);

    if (lutando)
    {
      vidaText.text = '$vida ⚔️';
    }
    else
    {
      vidaText.text = '$vida';
    }
    vidaText.position = Vector2(size.x / 2, this.width / 10);

    //LUTANDO
    if (!lutando)
    {
      //cancela o sendo empurrado
      if (sendoEmpurrado)
      {
        sendoEmpurrado = false;
      }

      Vector2 displacement = direction - position;
      double distance = displacement.length;

      colidiu = c_dir || c_esq || c_cima || c_baixo;

      if (distance > 0) {
        Vector2 normalizedDirection = displacement / distance;
        double maxStep = speed * dt;
        if (maxStep > distance) {
          maxStep = distance;
        }

        if (c_dir && normalizedDirection.x > 0) {
          normalizedDirection = Vector2(0, normalizedDirection.y);
          c_dir = false;
        }
        if (c_esq && normalizedDirection.x < 0) {
          normalizedDirection = Vector2(0, normalizedDirection.y);
          c_esq = false;
        }
        if (c_baixo && normalizedDirection.y > 0) {
          normalizedDirection = Vector2(normalizedDirection.x, 0);
          c_baixo = false;
        }
        if (c_cima && normalizedDirection.y < 0) {
          normalizedDirection = Vector2(normalizedDirection.x, 0);
          c_cima = false;
        }

        if (colidiu) {
          direction = Vector2(Random().nextDouble() * gameRef.size.x,
          Random().nextDouble() * gameRef.size.y);
        } 

        if (!pausado)
          position += normalizedDirection * maxStep;
          
      } else {
        escolherNovoCaminho();
      }
    }
    else  //LUTANDO
    {
      /*
      //faz ficar parado
      tempoDeLuta -= dt;
      if (tempoDeLuta <= 0) {             //os pausa no confronto
        
        //sendoEmpurrado = true;            //permite o knockback
        tempoDeLuta = valor_tempoDeLuta;
      }
      */
      if (sendoEmpurrado) {               //executa o knockback
        // Verifica colisões durante o knockback: zera as componentes da velocidade
        // que apontam para a direção de uma parede
        if (c_dir && knockbackVelocity.x > 0) knockbackVelocity.x = 0;
        if (c_esq && knockbackVelocity.x < 0) knockbackVelocity.x = 0;
        if (c_baixo && knockbackVelocity.y > 0) knockbackVelocity.y = 0;
        if (c_cima && knockbackVelocity.y < 0) knockbackVelocity.y = 0;

        // Aplica o knockback
        position += knockbackVelocity * dt;
        knockbackVelocity *= knockbackDecay;
        if (knockbackVelocity.length < 0.1) {
          sendoEmpurrado = false;
          lutando = false;
        }

        //escolherNovoCaminho();
      }
    } 
    
  }

  void escolherNovoCaminho() {
    direction = Vector2(
      Random().nextDouble() * gameRef.size.x,
      Random().nextDouble() * gameRef.size.y,
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Parede) {
      final intersection_f = intersectionPoints.first;
      final intersection_l = intersectionPoints.last;

      if (intersection_l.x == intersection_f.x) {
        if (intersection_f.x > absoluteCenter.x) {
          c_dir = true;
        }
        if (intersection_f.x < absoluteCenter.x) {
          c_esq = true;
        }
      } else if (intersection_l.y == intersection_f.y) {
        if (intersection_f.y < absoluteCenter.y) {
          c_cima = true;
        }
        if (intersection_f.y > absoluteCenter.y) {
          c_baixo = true;
        }
      }
    }
  }

  void knockback(Vector2 collisionNormal, double force) {
    knockbackVelocity = collisionNormal.normalized() * force;
    sendoEmpurrado = true;
  }

  void apanha(int dano) {
    print("Enemey tomou $dano de dano. Vida antes: $vida");

    vida -= dano;
    if (vida <= 0) {
      vida = 0;
      print("Enemy morreu!");
      removeFromParent(); // Remove o inimigo do jogo
    }

    print("Vida depois: $vida");
  }
}

