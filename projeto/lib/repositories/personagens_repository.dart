import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:http/http.dart' as http;

class PersonagensRepository extends ChangeNotifier {
  final List<Personagem> _lista = []; // essa lista agora é atualizada pela requisição http da mock api

  final List<Personagem> _listaObtidos = [];

  late FirebaseFirestore db = FirebaseFirestore.instance;
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  UnmodifiableListView<Personagem> get lista => UnmodifiableListView(_lista);

  UnmodifiableListView<Personagem> get listaObtidos => UnmodifiableListView(_listaObtidos);

  PersonagensRepository();

  Future<void> init() async{
    clear();

    await fetchTodosPersonagens(); // carrega todos os personagens da api

    List<Personagem> personagens = await carregarPersonagens();
    saveAll(personagens);

    shaveList(); // varre a lista (remove os personagens já obtidos da lista principal trazida da api)

    notifyListeners();
  }

  void obterPersonagem(String id){
    try {
      if (_lista.isEmpty) {
        throw Exception("Lista de personagens ainda não carregada!");
      }

      Personagem personagemNovo = _lista.firstWhere((p) => p.id == id, orElse: () => throw Exception("Personagem não encontrado"));
      
      saveAll([personagemNovo]);
      shaveList();
      salvarPersonagemNoFirebase([personagemNovo]);
    } catch (e) {
      print("Erro ao obter personagem: $e");
    }
  }

  Personagem getPersonagemRandomNaoObtido(){
    return (_lista..shuffle()).first;
  }

  void clear(){
    _lista.clear();
    _listaObtidos.clear();
  }

  // Função para salvar todos os personagens na lista
  void saveAll(List<Personagem> personagens) {
    for (var personagem in personagens) {
      if (!_listaObtidos.contains(personagem)) _listaObtidos.add(personagem);
    }
    notifyListeners();
  }

  // Função para mover personagem para uma nova posição
  void move(Personagem personagem, int posicao) {
    personagem.posicao = posicao;
    notifyListeners();
  }

  // Função para salvar personagens no Firestore
  Future<void> salvarPersonagemNoFirebase(List<Personagem> personagensEscolhidos) async {
    try {
      WriteBatch batch = db.batch();
      CollectionReference personagensRef = db.collection('users').doc(_auth.currentUser?.uid).collection('personagens');

      for (var personagem in personagensEscolhidos) {
        DocumentReference docRef = personagensRef.doc(personagem.id);
        batch.set(docRef, {
          'id': personagem.id,
          'nome': personagem.nome,
          'imagem': personagem.imagem,
          'classe': personagem.classe,
          'posicao': personagem.posicao,
          'checado' : personagem.checado,
          'vida' : personagem.vida,
          'danoMin' : personagem.danoMin,
          'danoMax' : personagem.danoMax,
          'velocidade' : personagem.velocidade,
          'nivel' : personagem.nivel,
        });
      }

      await batch.commit();
    } catch (e) {
      print("Erro ao salvar posições no Firebase: $e");
    }
    notifyListeners();
  }

  // Função para carregar personagens do Firestore
  Future<List<Personagem>> carregarPersonagens() async {
    try {
      QuerySnapshot snapshot = await  db.collection('users').doc(_auth.currentUser?.uid).collection('personagens').get();

      List<Personagem> personagensCarregados = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Personagem(
          id: data['id'] ?? '',
          nome: data['nome'] ?? '',
          imagem: data['imagem'] ?? 'assets/images/guerreiro.png',
          classe: data['classe'] ?? 'ally',
          posicao: data['posicao'] ?? 0,
          checado: data['checado'] ?? false,
          vida: data['vida'] ?? 0,
          danoMin: data['danoMin'] ?? 0,
          danoMax: data['danoMax'] ?? 0,
          velocidade: data['velocidade'] ?? 0,
          nivel: data['nivel'] ?? 1,
        );
      }).toList();
      return personagensCarregados;
    } catch (e) {
      print("Erro ao carregar personagens do Firebase: $e");
      return [];
    }
  }

  List<Personagem> getPersonagensEscolhidos(){
    List<Personagem> personagensEscolhidos = [];

    for (Personagem personagem in _listaObtidos){
      if (personagem.checado == true){
        personagensEscolhidos.add(personagem);
      }
    }
    
    return personagensEscolhidos;
  }

  Future<void> fetchTodosPersonagens() async {
    const String url = 'https://67a78303203008941f67ce34.mockapi.io/personagens';

    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Personagem> personagens  = data.map((json) => Personagem.fromJson(json)).toList();
      _lista.addAll(personagens);
      notifyListeners();
    } else {
      throw Exception('Falha ao carregar personagens');
    }

  }

  void shaveList() {
    _lista.removeWhere((personagem) => _listaObtidos.any((p) => p.id == personagem.id));
  }

}