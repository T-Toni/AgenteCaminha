import 'dart:async';
//import 'package:flame/collisions.dart';
import 'package:projeto/attacks/attack.dart';
import 'package:flame/components.dart';
//import 'package:flutter/material.dart';
import 'package:projeto/actors/enemies/enemy.dart';
import 'package:projeto/attacks/heal.dart';
import 'package:projeto/actors/allies/ally.dart';
import 'dart:math';
import 'package:projeto/world/parede.dart';

class Healer extends Ally {
  double speed;
  Vector2 direction;
  Vector2 knockbackVelocity = Vector2.zero();
  double knockbackDecay = 0.9;
  bool sendoEmpurrado = false;
  bool colidiu = false;
  bool c_dir = false;
  bool c_esq = false;
  bool c_cima = false;
  bool c_baixo = false;

  int min_dano;
  int max_dano;
  int min_acerto;
  int max_acerto;
  int cooldown;
  int iframe;
  int vida;
  List<Ally> aliados = []; // Lista de aliados carregados no jogo
  double tempoCura = 0; // Contador de tempo para a cura
  double intervaloCura = 5.0;
  bool atacando = false;
  bool curando = false;
  late TextComponent vidaText;

  Healer({
    required this.speed,
    required this.direction,
    required this.min_dano,
    required this.max_dano,
    required this.vida,
    required this.min_acerto,
    required this.max_acerto,
    required this.cooldown,
    required this.iframe,
    required this.aliados,
  }) : super(
          speed: 100,
          direction: Vector2(600, 600),
          min_dano: 5,
          max_dano: 20,
          vida: 10000,
          min_acerto: 1,
          max_acerto: 10,
        ) {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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
    //atualiza a vida
    // Atualiza o contador de tempo para a cura
    tempoCura += dt;

    // Se o tempo de cura atingir o intervalo, realiza a cura
    if (tempoCura >= intervaloCura && !lutando) {

      curando = true;

      //delay até a cura ser calculada
      tempoDeLuta -= dt;
      if (tempoDeLuta <= 0) {
        
        Heal heal = Heal();
        for (Ally ally in aliados) {
          heal.heal(this, ally); // Cura todos os aliados
        }
        tempoCura = 0; // Reseta o contador
        curando = false;
        tempoDeLuta = valor_tempoDeLuta;
      }

    }

    if (!isLoaded) return;

    if (lutando) {
      vidaText.text = '$vida ⚔️';
    } else if (curando){
      vidaText.text = '$vida ❤️';
    }
    else
    {
      vidaText.text = '$vida';
    }
    vidaText.position = Vector2(size.x / 2, this.width / 10);

    if (!lutando && !curando) {
      Vector2 displacement = direction - position;
      double distance = displacement.length;

      colidiu = c_dir || c_esq || c_cima || c_baixo;

      if (distance > 0) {
        Vector2 normalizedDirection = displacement / distance;
        double maxStep = speed * dt;
        if (maxStep > distance) maxStep = distance;

        //confere as colisões com a parede
        if (c_dir && normalizedDirection.x > 0) normalizedDirection.x = 0;
        if (c_esq && normalizedDirection.x < 0) normalizedDirection.x = 0;
        if (c_baixo && normalizedDirection.y > 0) normalizedDirection.y = 0;
        if (c_cima && normalizedDirection.y < 0) normalizedDirection.y = 0;

        c_dir = c_esq = c_baixo = c_cima = false;
        position += normalizedDirection * maxStep;

        if (colidiu) {
          direction = Vector2(Random().nextDouble() * gameRef.size.x,
              Random().nextDouble() * gameRef.size.y);
        }
      } else {
        direction = Vector2(Random().nextDouble() * gameRef.size.x,
            Random().nextDouble() * gameRef.size.y);
      }
    } 
    else if (lutando)//fica parado por um tempo e depois executa o ataque
    {
      //delay até a luta ser calculada
      tempoDeLuta -= dt;
      if (tempoDeLuta <= 0) {
        //os pausa no confronto

        Ataque ataque = Ataque();
        ataque.ataque(this, adversario);
        //sendoEmpurrado = true;            //permite o knockback
        tempoDeLuta = valor_tempoDeLuta;
      }

      if (sendoEmpurrado) {
        //executa o knockback
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
