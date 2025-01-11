import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';

class PersonagensRepository extends ChangeNotifier {
  final List<Personagem> _lista = [
    Personagem(id: '1', nome: 'Guerreiro', imagem: 'assets/images/guerreiro.png', posicao: 0, vida: 0, dano: 0, velocidade: 0),
    Personagem(id: '2', nome: 'Curandeira', imagem: 'assets/images/curandeira.png', posicao: 0, vida: 0, dano: 0, velocidade: 0),
    Personagem(id: '3', nome: 'Mago', imagem: 'assets/images/mago.png', posicao: 0, vida: 0, dano: 0, velocidade: 0),
    //Personagem(id: '4', nome: 'padre', imagem: 'assets/images/padre.png', posicao: 0, vida: 0, dano: 0, velocidade: 0),
  ];

  final List<Personagem> _listaObtidos = [];

  late FirebaseFirestore db = FirebaseFirestore.instance;
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  UnmodifiableListView<Personagem> get lista => UnmodifiableListView(_lista);
  UnmodifiableListView<Personagem> get listaObtidos => UnmodifiableListView(_listaObtidos);

  PersonagensRepository(){
    carregarPersonagens().then((personagens){
      saveAll(personagens);
    });
    notifyListeners();
  }

  void obterPersonagem(String id){
    Personagem personagemNovo = lista.where((p) => p.id == id).first;
    saveAll([personagemNovo]);
  }

  // Função para salvar todos os personagens na lista
  void saveAll(List<Personagem> personagens) {
    for (var personagem in personagens) {
      if (!_listaObtidos.contains(personagem)) _listaObtidos.add(personagem);
    }
    notifyListeners();
  }

  // Função para remover personagem da lista
  void remove(Personagem personagem) {
    _listaObtidos.remove(personagem);
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
          'posicao': personagem.posicao,
          'checado' : personagem.checado,
          'vida' : personagem.vida,
          'dano' : personagem.dano,
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
          imagem: data['imagem'] ?? '',
          posicao: data['posicao'] ?? 0,
          checado: data['checado'] ?? false,
          vida: data['vida'] ?? 0,
          dano: data['dano'] ?? 0,
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

    for (Personagem personagem in listaObtidos){
      if (personagem.checado == true){
        personagensEscolhidos.add(personagem);
      }
    }
    
    return personagensEscolhidos;
  }
}