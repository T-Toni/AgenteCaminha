import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:projeto/models/personagem.dart';
import 'package:projeto/pages/recompensas.dart';
import 'package:projeto/repositories/personagens_repository.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Home extends StatefulWidget {
  final ValueNotifier<bool> caminhandoNotifier;
  
  Home({super.key, required this.caminhandoNotifier});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late PersonagensRepository personagens;
  
  List<int> estadosGrid = List<int>.filled(15, 0);
  
  Personagem? marcado;

  List<Personagem> personagensEscolhidos = [];
  
  late MapController mapController;
  double kmcaminhados = 0.0;
  List<GeoPoint> caminhoPercorrido = [];
  Position? ultimaPosicao;
  StreamSubscription<Position>? positionStream;

  void marcarPersonagem(Personagem personagem, int index) {
    setState(() {
      estadosGrid[index] = (estadosGrid[index] + 1) % 2; // Alterna entre 0 e 1
    });
    marcado = personagem;
  }

  void trocarPosicao(int index){
    if (marcado != null){
      Personagem? personagemTroca = getPersonagemNaPosicao(index, personagensEscolhidos);
      if (personagemTroca != null){
        personagens.move(personagemTroca, marcado!.posicao);
      }
    personagens.move(marcado!, index);
    marcado = null;
    estadosGrid.fillRange(0, 15, 0);
    salvarPosicoes();
    }
  }

  Personagem? getPersonagemNaPosicao(int posicao, List lista) {
    final personagem = lista.where((p) => p.posicao == posicao);
    return personagem.isNotEmpty ? personagem.first : null;
  }

  void salvarPosicoes() {
    personagens.salvarPersonagemNoFirebase(personagensEscolhidos);
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController.withUserPosition(
        trackUserLocation: UserTrackingOption(
           enableTracking: true,
           unFollowUser: false,
        )
    );
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Serviço de localização não habilitado, não pode continuar
      return Future.error('Serviço de localização está desabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissão de localização negada, não pode continuar
        return Future.error('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissão de localização negada permanentemente, não pode continuar
      return Future.error('Permissão de localização negada permanentemente.');
    }

    // Obtém a posição atual do usuário
    Position position = await Geolocator.getCurrentPosition();
    print('Posição atual: ${position.latitude}, ${position.longitude}');

    /*
    await mapController.moveTo(
      GeoPoint(latitude: position.latitude, longitude: position.longitude),
    );
    */
  }

  void _startTracking() {
    if (positionStream != null) {
      positionStream!.cancel();
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Atualiza a cada 10 metros
      ),
    ).listen((Position position) async {
      if (mounted) {
        setState(() {
          caminhoPercorrido.add(GeoPoint(
            latitude: position.latitude,
            longitude: position.longitude,
          ));
          if (ultimaPosicao != null) {
            kmcaminhados += Geolocator.distanceBetween(
              ultimaPosicao!.latitude,
              ultimaPosicao!.longitude,
              position.latitude,
              position.longitude,
            ) / 1000; // Converte para km
          }
          ultimaPosicao = position;
        });
        if ((caminhoPercorrido.length > 1) && (caminhoPercorrido[caminhoPercorrido.length - 2].latitude != caminhoPercorrido.last.latitude || caminhoPercorrido[caminhoPercorrido.length - 2].longitude != caminhoPercorrido.last.longitude)) {
          //mapController.clearAllRoads();

          await mapController.drawRoad(
            caminhoPercorrido[caminhoPercorrido.length - 2],
            caminhoPercorrido.last,
            roadType: RoadType.foot,
            roadOption: RoadOption(
              roadColor: Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256)),
              roadWidth: 10,
            ),
        );
      }

      }
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    personagens = context.watch<PersonagensRepository>();

    personagensEscolhidos = personagens.getPersonagensEscolhidos();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Posiciona a grid no final da tela
      children: [
        //Expanded(child: Container()),
        Container(
          height: 250,
          child: OSMFlutter( 
            controller: mapController,
            osmOption: OSMOption(
                userTrackingOption: UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: ZoomOption(
                initZoom: 18,
                minZoomLevel: 16,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.purple,
                    size: 40,
                  ),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.purple,
                    size: 40,
                  ),
                ),
              ),
            )
          )
        ),
        Center(
          child: 
          Text(widget.caminhandoNotifier.value?
            '${kmcaminhados.toStringAsFixed(3)} Km caminhados' : 'Aquecendo para a caminhada...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
            child: Text(widget.caminhandoNotifier.value? 'Terminar caminhada e ganhar recompensas' : 'Iniciar caminhada'),
            onPressed: widget.caminhandoNotifier.value? () => {
              // ENTRANDO NA TELA DE RECOMPENSAS
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TelaRecompensas(kmcaminhados),
                  ),
              ).then((result) async {
                // VOLTANDO DA TELA DE RECOMPENSAS
                List<GeoPoint> geoPoints = await mapController.geopoints;
                mapController.removeMarkers(geoPoints);
                mapController.clearAllRoads();
                if(mounted){
                  setState(() {
                    caminhoPercorrido.clear();
                    kmcaminhados = 0.0;
                    ultimaPosicao = null;
                    positionStream?.cancel();
                  });
                }
                setState(() {
                  widget.caminhandoNotifier.value = false;
                  caminhoPercorrido.clear();
                  kmcaminhados = 0.0;
                  ultimaPosicao = null;
                });
              }
              )
            }: () async {
              // INICIANDO A CAMINHADA
              try {
                
                Position position = await Geolocator.getCurrentPosition();

                print(position);

                await mapController.addMarker(
                  GeoPoint(latitude: position.latitude, longitude: position.longitude),
                  markerIcon: MarkerIcon(
                    icon: Icon(
                      Icons.pin_drop,
                      color: Colors.purple,
                      size: 20,
                    ),
                  ),
                );
                print('Marcador adicionado com sucesso');
              } catch (e) {
                print('Erro ao adicionar marcador: $e');
              }
              if (mounted){
                setState(() {
                  widget.caminhandoNotifier.value = true;
                });
              }
              _startTracking();
            },
          )
        ),
        Container(
          height: 250, // Altura da grid 3 linhas
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromARGB(0, 224, 224, 224),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // Desativa o scroll
            itemCount: 15, // 5x3 = 15 blocos
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 5 colunas de lado a lado
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemBuilder: (context, index) {
              final personagemDisplay = getPersonagemNaPosicao(index, personagensEscolhidos);
              return GestureDetector(
                onTap: () => (personagemDisplay != null && marcado == null)
                          ? marcarPersonagem(personagemDisplay, index)
                          : trocarPosicao(index), // Altera o estado ao clicar
                child: Container(
                  decoration: BoxDecoration(
                    color: estadosGrid[index] == 0 ? Colors.white : const Color.fromARGB(255, 140, 68, 255),
                    borderRadius: BorderRadius.circular(8),
                    image: personagemDisplay != null
                          ? DecorationImage(
                              image: AssetImage(personagemDisplay.imagem),
                              fit: BoxFit.cover,
                            )
                          : null, // Aplica a imagem do personagem, se houver
                  ),
                ),
              );
            },
          ),
        ),
        /*
        ElevatedButton(
            onPressed:
                salvarPosicoes, // Botão para salvar as posições no Firebase
            child: const Text('Salvar Posições'),
        )
        */
      ],
    );
  }
}