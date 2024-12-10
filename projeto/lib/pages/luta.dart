//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';
import 'package:projeto/pages/game_sprite_sheet.dart' as ss;

final double tileSize = 16;

class Luta extends StatefulWidget {
  const Luta({super.key});

  @override
  State<Luta> createState() => _LutaState();
}

class _LutaState extends State<Luta> {

   @override
  Widget build(BuildContext context) {

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

        components: [

        GameDecoration.withSprite(
         
          position: Vector2(13 * tileSize, 21 * tileSize),
          size: Vector2(tileSize*2, tileSize*2),
          sprite: Sprite.load('mago.png'),

          )

          //Goblin(Vector2(0*tileSize, 0*tileSize), "mago.png")
        ],

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