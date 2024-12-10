//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/pages/game_sprite_sheet.dart' as ss;
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:provider/provider.dart';

final double tileSize = 16;
late PersonagensRepository personagens;

class Luta extends StatefulWidget {
  const Luta({super.key});

  @override
  State<Luta> createState() => _LutaState();
}

class _LutaState extends State<Luta> {

  List<GameDecoration> criarDecoracoes(List<Personagem> personagensEscolhidos, double tileSize) {
    return personagensEscolhidos.map((personagem) {
      return GameDecoration.withSprite(
        position: Vector2(13 + ((personagem.posicao+1)~/5) * 2 * tileSize, 21 + 2 * ((personagem.posicao+1) % 5) * tileSize),
        size: Vector2(tileSize, tileSize),
        sprite: Sprite.load('mago.png'),
      );
    }).toList();
  }
   @override
  Widget build(BuildContext context) {

    personagens = context.watch<PersonagensRepository>();

    var personagensEscolhidos = personagens.getPersonagensEscolhidos();

    List<GameDecoration> decorations = criarDecoracoes(personagensEscolhidos, tileSize);

    return Scaffold(
    body: BonfireWidget(
      playerControllers: [
        Joystick(
          directional: JoystickDirectional(),
        )
      ],

      map: WorldMapByTiled(

        WorldMapReader.fromAsset("map.json"),
      
        //Uri.parse('https://raw.githubusercontent.com/RafaelBarbosatec/rafaelbarbosatec.github.io/master/tiled/my_map.json')
        
        ),

        components: decorations,

        cameraConfig: CameraConfig(
          moveOnlyMapArea: true,
        ),

      )
      
      

    );

  }

}

class Goblin extends SimpleAlly {

    Goblin(Vector2 position, String imagem)
      : super(
          position: position, // required
          size: Vector2(32.0,32.0), // required
          life: 100,
          speed: 100,
          initDirection: Direction.right,
          animation: SimpleDirectionAnimation(
            idleRight: ss.GameSpriteSheet().magoIdRight,
            runRight: ss.GameSpriteSheet().magoRunRight,
          ),
      );

    @override
    void update(double dt) {
      // do anything
      super.update(dt);
    }

    @override
    void render(Canvas canvas) {
      // do anything

      

      // canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
      super.render(canvas);
    }
}