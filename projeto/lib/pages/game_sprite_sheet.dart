import 'package:bonfire/bonfire.dart';

class GameSpriteSheet {
  Future<SpriteAnimation> get magoIdRight => SpriteAnimation.load(
    'mago.png',
    SpriteAnimationData.sequenced(amount: 1, stepTime: 1, textureSize: Vector2(32, 32)),
  );
  Future<SpriteAnimation> get magoRunRight => SpriteAnimation.load(
    'mago.png',
    SpriteAnimationData.sequenced(amount: 1, stepTime: 1, textureSize: Vector2(32, 32)),
  );
}