import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';

final tileSize = 32;

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

        WorldMapReader.fromAsset("mapa1.json")

        //Uri.parse('https://raw.githubusercontent.com/RafaelBarbosatec/rafaelbarbosatec.github.io/master/tiled/my_map.json')
        
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
            idleRight: Future<SpriteAnimation>(
              SpriteAnimation.load(
                imagem, 
                SpriteAnimationData.sequenced(amount: 1, stepTime: 0, textureSize: Vector2(32, 32))
              ) as FutureOr<SpriteAnimation> Function()
            ), // required 
            runRight: Future<SpriteAnimation>(
              SpriteAnimation.load(
                imagem, 
                SpriteAnimationData.sequenced(amount: 1, stepTime: 0, textureSize: Vector2(32, 32))
              ) as FutureOr<SpriteAnimation> Function()
              ), // required
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
      super.render(canvas);
    }
}