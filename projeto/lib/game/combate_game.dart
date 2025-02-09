import 'dart:async';
import 'dart:ui';
import 'package:projeto/actors/allies/healer.dart';
import 'package:projeto/actors/allies/invoker.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/world/parede.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:projeto/actors/allies/ally.dart';
import 'package:projeto/actors/enemies/enemy.dart';

class Combategame extends FlameGame with HasCollisionDetection {
  final List<Personagem> personagens;

  Combategame({required this.personagens});

  @override
  Color backgroundColor() => const Color(0xFF25131A);

  late Enemy orc_chefe;
  late Enemy orc_capanga1;
  late Enemy orc_capanga2;
  late Enemy orc_capanga3;

  //late Ally ally;
  List<Invoker> invokers = [];
  List<Ally> aliados = [];

  late TiledComponent mapa1; // Usando TiledComponent diretamente

  @override
  FutureOr<void> onLoad() async {
    // Obtém as dimensões da tela
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize/1.5;
    double width = size.width;
    double height = size.height;

    double ajuste = width / 480; //          / 480;

    // Carrega o mapa
    mapa1 = await TiledComponent.load('dungeon_1.tmx', Vector2.all(24 * ajuste));

    add(
      mapa1..position = Vector2(0, 0),
    );

    // Instancia os personagens
    orc_chefe = Enemy(
      speed: 25,
      direction: Vector2(200, 200),
      min_dano: 5,
      max_dano: 40,
      vida: 500,
      min_acerto: 1,
      max_acerto: 10,
    );

    orc_capanga1 = Enemy(
      speed: 25,
      direction: Vector2(2000, 0),
      min_dano: 5,
      max_dano: 20,
      vida: 125,
      min_acerto: 1,
      max_acerto: 10,
    );

    orc_capanga2 = Enemy(
      speed: 25,
      direction: Vector2(-200, 200),
      min_dano: 5,
      max_dano: 20,
      vida: 125,
      min_acerto: 1,
      max_acerto: 10,
    );

    orc_capanga3 = Enemy(
      speed: 25,
      direction: Vector2(100, -200),
      min_dano: 5,
      max_dano: 20,
      vida: 125,
      min_acerto: 1,
      max_acerto: 10,
    );

    for (Personagem p in personagens) {
      if (p.classe == 'invoker') {
        Invoker invoker = Invoker(
          min_dano: p.danoMin, //5
          max_dano: p.danoMax * 10, //20
          vida: p.vida * 50, //50
          min_acerto: 1, // 1 sempre
          max_acerto: 10, // nao sei af
          cooldown: 2, // ?
          iframe: 2, // ?
          ajuste: ajuste,
        );
        aliados.add(invoker);
        invokers.add(invoker);
        await add(
            invoker
            ..sprite = await loadSprite(p.imagem.replaceFirst('assets/images/', ''))
            ..size = Vector2.all(24 * ajuste * 2)
            ..position = Vector2(100, 550), // Mudando posição para evitar colisão
        );
      } else if (p.classe == 'ally') {
        Ally ally = Ally(
          speed: 100, // ?
          direction: Vector2(600, 600), // ?
          min_dano: p.danoMin, // 5
          max_dano: p.danoMax * 10, // 20
          vida: p.vida * 50, // *50 seria um multiplicador de vida padrão
          min_acerto: 1,
          max_acerto: 10,
        );
        aliados.add(ally);
        await add(
            ally
            ..sprite = await loadSprite(p.imagem.replaceFirst('assets/images/', ''))
            ..size = Vector2.all(24 * ajuste * 1.5)
            ..position = Vector2(150, 400), // Mudando posição para evitar colisão
        );
      } else if (p.classe == 'healer') {
        Healer healer = Healer(
          speed: 20,
          direction: Vector2(600, 600),
          min_dano: p.danoMin, // 1
          max_dano: p.danoMax * 10, // 10
          vida: p.vida*50, // 50
          min_acerto: 1,
          max_acerto: 10,
          cooldown: 2,
          iframe: 2,
          aliados: aliados,
        );
        await add(
            healer
            ..sprite = await loadSprite(p.imagem.replaceFirst('assets/images/', ''))
            ..size = Vector2.all(24 * ajuste * 1.5)
            ..position = Vector2(200, 550), // Mudando posição para evitar colisão
        );
      }
    }
    // Adiciona os personagens ao jogo
    await addAll([
      //inimigos
      orc_chefe
        ..sprite = await loadSprite('actors/idle-orc.png')
        ..size = Vector2.all(24 * ajuste * 2)
        ..position = Vector2(width / 5, height / 5),

      orc_capanga1
        ..sprite = await loadSprite('actors/idle-orc.png')
        ..size = Vector2.all(24 * ajuste * 1.5)
        ..position = Vector2(width / 5, height / 4),

      orc_capanga2
        ..sprite = await loadSprite('actors/idle-orc.png')
        ..size = Vector2.all(24 * ajuste * 1.4)
        ..position = Vector2(width / 10, height / 4),

      orc_capanga3
        ..sprite = await loadSprite('actors/idle-orc.png')
        ..size = Vector2.all(24 * ajuste * 1.3)
        ..position = Vector2(width / 10 * 3, height / 4),
    ]);

    // Adiciona colisões do mapa
    final obstacleGroup = mapa1.tileMap.getLayer<ObjectGroup>('paredes');

    if (obstacleGroup != null) {
      for (final obj in obstacleGroup.objects) {
        add(
          Parede(
            size: Vector2(obj.width * ajuste, obj.height * ajuste),
            position: Vector2(obj.x * ajuste, obj.y * ajuste + 50),
          ),
        );
      }
    } else {
      print(
          "⚠️ Camada 'paredes' não encontrada no mapa! Verifique o arquivo .tmx.");
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    //orc.update(dt);
    //ally.update(dt);
    for (Invoker invoker in invokers) {
      invoker.update(dt);
    }

    super.update(dt);
  }
}
