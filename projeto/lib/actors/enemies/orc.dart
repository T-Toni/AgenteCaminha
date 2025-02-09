/*
import 'dart:math';

import 'package:combate/main.dart';
import 'package:combate/world/parede.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:combate/actors/enemies/attack.dart';


//extends SpriteComponent significa que a classe enemy é um componente de sprite - ou seja, um objeto que pode ser desenhado na tela
//implements CollisionCallbacks significa que a classe enemy implementa a interface CollisionCallbacks
class enemy extends SpriteComponent with CollisionCallbacks, HasGameRef<Combategame> {

  // Variáveis do objeto enemy
  double speed;
  Vector2 direction;

  bool colidiu = false;
  bool c_dir = false;
  bool c_esq = false;
  bool c_cima = false;
  bool c_baixo = false;

  //mecanica de ataque
  int min_dano = 10;
  int max_dano = 50;
  int min_acerto = 0;
  int max_acerto = 0;
  int cooldown = 2;
  int iframe = 2;
  int vida = 100;


  


  // Construtor que recebe as variáveis como parâmetros
  enemy({required this.speed, required this.direction}) : super() {
    debugMode = true;
  }

  @override
  Future<void>onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());

  }


//função de colisão       (IDEIA: fazer com que o ataque ocorra aqui, caso o enemy collida com um aliado)
@override
void onCollision(Set<Vector2> intersectionPoints, other) {
  super.onCollision(intersectionPoints, other);

  //colisão se parede
  if (other is Parede) {
    print('Colidiu com a parede');

    //implementar detecção da direção da colisão e impedir no movimento acrescimo nessa direção
    // Calcular a direção da colisão
    final intersection_f = intersectionPoints.first;
    final intersection_l = intersectionPoints.last;
    
    print(intersection_f);
    print(intersection_l);

    // Determinar a direção da colisão
    if (intersection_l.x == intersection_f.x) //colisão na vertical (direita-esquerda)
    {
      if(intersection_f.x > absoluteCenter.x) //colisão na direita
      {
        print('Colisão na direita');
        c_dir = true;
      }

      
      if(intersection_f.x < absoluteCenter.x) //colisão na esquerda
      {
        print('Colisão na esquerda');
        c_esq = true;
      }

    }
    else if (intersection_l.y == intersection_f.y) //colisão na horizontal
    {
      if(intersection_f.y < absoluteCenter.y) //colisão em cima
      {
        print('Colisão em cima');
        c_cima = true;
      }


      if(intersection_f.y > absoluteCenter.y) //colisão em baixo
      {
        print('Colisão em baixo');  
        c_baixo = true;
      }

    }
  }

  //if (other is ally)

}


  //código a cada frame
  void update(double dt) {
    // Calcula o deslocamento baseado na velocidade e no tempo
    Vector2 displacement = direction - position; // Vetor na direção do destino
    double distance = displacement.length;  // Distância até o destino

    if(c_dir == true||c_esq == true||c_cima == true||c_baixo == true)
    {
      colidiu = true;
    }
    else
    {
      colidiu = false;
    }
    
    if (distance > 0) {
        // Normaliza o deslocamento para obter a direção
        Vector2 normalizedDirection = displacement / distance;

        // Calcula o movimento máximo permitido neste frame
        double maxStep = speed * dt;

        // Se o movimento for maior que a distância restante, ajuste para parar no destino
        if (maxStep > distance) {
            maxStep = distance;
        }

        //confere colisões
        if(c_dir == true)
        {
          if(normalizedDirection.x > 0)
          {
            normalizedDirection = Vector2(0, normalizedDirection.y);
          }
          c_dir = false;
        }
        if(c_esq == true)
        {
          if(normalizedDirection.x < 0)
          {
            normalizedDirection = Vector2(0, normalizedDirection.y);
          }
          c_esq = false;
        }
        if(c_baixo == true)
        {
          if(normalizedDirection.y > 0)
          {
            normalizedDirection = Vector2(normalizedDirection.x, 0);
          }
          c_baixo = false;
        }
        if(c_cima == true)
        {
          if(normalizedDirection.y < 0)
          {
            normalizedDirection = Vector2(normalizedDirection.x, 0);
          }
          c_cima = false;
        }


        // Atualiza a posição
        position += normalizedDirection * maxStep;
    }
    else
    {
      // Se o destino for alcançado, escolha um novo destino aleatório
      direction = Vector2(Random().nextDouble() * gameRef.size.x, Random().nextDouble() * gameRef.size.y);
    }

    if(colidiu == true)
    {
      direction = Vector2(Random().nextDouble() * gameRef.size.x, Random().nextDouble() * gameRef.size.y);
    }
    
    print(c_dir);
    print(c_esq);
    print(c_cima);
    print(c_baixo);

  }

  // Função de ataque: dispara um componente de ataque
  void attack() async {
    
  }

  void apanha(){
    //pass
  }
}
*/
