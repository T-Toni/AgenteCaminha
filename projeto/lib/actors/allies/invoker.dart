import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
//import 'package:flutter/material.dart';
import 'package:projeto/actors/enemies/enemy.dart';
import 'package:projeto/attacks/attack.dart';
import 'package:projeto/actors/allies/ally.dart';

class Invoker extends Ally{
  int min_dano;
  int max_dano;
  int min_acerto;
  int max_acerto;
  int cooldown;
  int iframe;
  int vida;
  
  double ajuste;

  bool atacando = false;
  //late TextComponent vidaText;
  late TimerComponent invocacaoTimer;

  // Lista para controlar os aliados invocados
  final List<Ally> aliadosInvocados = [];
  final int maxAliados = 5; // Define um limite máximo

  Invoker({
    required this.min_dano,
    required this.max_dano,
    required this.vida,
    required this.min_acerto,
    required this.max_acerto,
    required this.cooldown,
    required this.iframe,
    required this.ajuste,
  }) : super(
          speed: 0, // Invoker não se move
          direction: Vector2.zero(), // Sem direção, pois é fixo
          min_dano: min_dano,
          max_dano: max_dano,
          vida: vida,
          min_acerto: min_acerto,
          max_acerto: max_acerto,
        ) {
    //debugMode = true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox()..collisionType = CollisionType.active);


    // Timer para invocar aliados a cada 5 segundos
    invocacaoTimer = TimerComponent(
      period: 25,
      repeat: true,
      onTick: () => invocarAlly(),
    );
    add(invocacaoTimer);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      Ataque ataque = Ataque();
      ataque.ataque(this, other);
    }
  }

  void invocarAlly() async {
  if (parent == null) return; // Evita erro se o Invoker for removido do jogo

  // Remove aliados mortos da lista antes de verificar o limite
  aliadosInvocados.removeWhere((ally) => ally.parent == null);

  // Se o número de aliados vivos for maior ou igual ao máximo, não invoca
  if (aliadosInvocados.length >= maxAliados) return;

  final outroAlly = Ally(
    speed: 100,
    direction: Vector2(200, 200),
    min_dano: 5,
    max_dano: 20,
    vida: 25,
    min_acerto: 1,
    max_acerto: 10,
  );

  parent!.add(
    outroAlly
      ..sprite = await Sprite.load('actors/guerreiro.png')
      ..size = Vector2.all(24 * ajuste)
      ..position = Vector2(this.position.x, this.position.y + 20), // Para evitar colisão
  );

  aliadosInvocados.add(outroAlly);
}


}

