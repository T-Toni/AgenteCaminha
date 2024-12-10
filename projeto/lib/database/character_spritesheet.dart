import 'package:bonfire/bonfire.dart';

class CharacterSpritesheet {
  final String path;
  static final _size = 16.0;

  CharacterSpritesheet({
    required String fileName,
  }) : path = fileName;
  
  SimpleDirectionAnimation getAnimation(){
    return SimpleDirectionAnimation(
      idleRight: idleRight,
      runRight: runRight
    );
  }

  Future<SpriteAnimation> get runRight => SpriteAnimation.load(
        path,
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );

  Future<SpriteAnimation> get idleRight => SpriteAnimation.load(
        path,
        SpriteAnimationData.sequenced(
          amount: 1,
          stepTime: 0.1,
          textureSize: Vector2(32, 32),
        ),
      );
}