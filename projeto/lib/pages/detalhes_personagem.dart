import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/repositories/user_info_repository.dart';
import 'package:provider/provider.dart';

class DetalhesPersonagemScreen extends StatefulWidget {
  final Personagem personagem;

  const DetalhesPersonagemScreen({Key? key, required this.personagem})
      : super(key: key);

  @override
  _DetalhesPersonagemScreenState createState() =>
      _DetalhesPersonagemScreenState();
}

class _DetalhesPersonagemScreenState extends State<DetalhesPersonagemScreen> {

  late UserInfoRepository userInfo;

  // Calcula o total de pontos distribuídos
  int get pontosDistribuidos =>
      widget.personagem.vida +
      widget.personagem.danoMax +
      widget.personagem.danoMin +
      widget.personagem.velocidade;

  // Verifica se ainda há pontos disponíveis para distribuir
  bool get podeAdicionarPontos =>
      userInfo.qntPontos > 0;

  @override
  Widget build(BuildContext context) {

    userInfo = context.watch<UserInfoRepository>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personagem.nome),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Container(
        color: colorScheme.inversePrimary, // Fundo no mesmo esquema de cores
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  widget.personagem.imagem,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.personagem.nome,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nível ${widget.personagem.nivel}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    if (podeAdicionarPontos)
                      Text(
                        '(${userInfo.qntPontos} pontos disponíveis)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CaracteristicaItem(
                titulo: "Vida",
                valor: widget.personagem.vida.toString(),
                podeAdicionar: podeAdicionarPontos,
                onIncrement: () {
                  setState(() {
                    widget.personagem.vida = widget.personagem.vida + 50; // QUANTIDADE DE VIDA ADICIONADA
                    widget.personagem.nivel++;
                    userInfo.removerPontos(1);
                  });
                },
              ),
              CaracteristicaItem(
                titulo: "Dano",
                valor: "${widget.personagem.danoMin} - ${widget.personagem.danoMax}",
                podeAdicionar: podeAdicionarPontos,
                onIncrement: () {
                  setState(() {
                    widget.personagem.danoMax = widget.personagem.danoMax + 10; // QUANTIDADE DE DANO MINIMO ADICIONADA
                    widget.personagem.danoMin = widget.personagem.danoMin + 1;  // QUANTIDADE DE DANO MAXIMO ADICIONADA
                    widget.personagem.nivel++;
                    userInfo.removerPontos(1);
                  });
                },
              ),
              CaracteristicaItem(
                titulo: "Velocidade",
                valor: widget.personagem.velocidade.toString(),
                podeAdicionar: podeAdicionarPontos,
                onIncrement: () {
                  setState(() {
                    widget.personagem.velocidade = widget.personagem.velocidade + 5;   // QUANTIDADE DE DANO ADICIONADA
                    widget.personagem.nivel++;
                    userInfo.removerPontos(1);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CaracteristicaItem extends StatelessWidget {
  final String titulo;
  final String valor;
  final VoidCallback onIncrement;
  final bool podeAdicionar; // Novo parâmetro para controlar a exibição do botão

  const CaracteristicaItem({
    super.key,
    required this.titulo,
    required this.valor,
    required this.onIncrement,
    required this.podeAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              Text(
                '$valor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 10),
              // O botão "+" só aparece se `podeAdicionar` for true
              if (podeAdicionar)
                IconButton(
                  icon: Icon(Icons.add_circle, color: colorScheme.primary),
                  onPressed: onIncrement,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
