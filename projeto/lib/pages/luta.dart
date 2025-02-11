import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:provider/provider.dart';

import '../game/combate_game.dart';

late PersonagensRepository personagens;

class Luta extends StatefulWidget {
  const Luta({super.key});

  @override
  State<Luta> createState() => _LutaState();
}

class _LutaState extends State<Luta> {

   @override
  Widget build(BuildContext context) {

    personagens = context.watch<PersonagensRepository>();
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                    title: Text('Combate'),
                    ),
                    body: Center(
                    child: GameWidget(
                      game: Combategame(personagens: personagens.getPersonagensEscolhidos())),
                    ),
                  ),
                  ),
                );
                },
                child: Text('Lutar'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }
}