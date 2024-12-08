import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:firebase_core/firebase_core.dart';

class PersonagensRepository extends ChangeNotifier {
  final List<Personagem> _lista = [
    Personagem(
        id: '1', nome: 'guerreiro', imagem: 'assets/bola1.png', posicao: 0),
    Personagem(
        id: '2', nome: 'curandeira', imagem: 'assets/bola2.png', posicao: 1),
    Personagem(id: '3', nome: 'mago', imagem: 'assets/mago.png', posicao: 2),
  ];

  late FirebaseFirestore db;

  // Construtor para inicializar o Firebase
  PersonagensRepository() {
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      db = FirebaseFirestore.instance;
    } catch (e) {
      print("Erro ao inicializar Firebase: $e");
    }
  }

  UnmodifiableListView<Personagem> get lista => UnmodifiableListView(_lista);

  // Função para salvar todos os personagens na lista
  void saveAll(List<Personagem> personagens) {
    for (var personagem in personagens) {
      if (!_lista.contains(personagem)) _lista.add(personagem);
    }
    notifyListeners();
  }

  // Função para remover personagem da lista
  void remove(Personagem personagem) {
    _lista.remove(personagem);
    notifyListeners();
  }

  // Função para mover personagem para uma nova posição
  void move(Personagem personagem, int posicao) {
    personagem.posicao = posicao;
    notifyListeners();
  }

  // Função para salvar personagens no Firestore
  Future<void> salvarPosicoesNoFirebase(
      List<Personagem> personagensEscolhidos) async {
    try {
      WriteBatch batch = db.batch();
      CollectionReference personagensRef = db.collection('personagens');

      for (var personagem in personagensEscolhidos) {
        DocumentReference docRef = personagensRef.doc(personagem.id);
        batch.set(docRef, {
          'id': personagem.id,
          'nome': personagem.nome,
          'imagem': personagem.imagem,
          'posicao': personagem.posicao,
        });
      }

      await batch.commit();
    } catch (e) {
      print("Erro ao salvar posições no Firebase: $e");
    }
  }

  // Função para carregar personagens do Firestore
  Future<List<Personagem>> carregarPersonagens() async {
    try {
      QuerySnapshot snapshot = await db.collection('personagens').get();

      List<Personagem> personagensCarregados = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Personagem(
          id: data['id'] ?? '',
          nome: data['nome'] ?? '',
          imagem: data['imagem'] ?? '',
          posicao: data['posicao'] ?? 0,
        );
      }).toList();

      return personagensCarregados;
    } catch (e) {
      print("Erro ao carregar personagens do Firebase: $e");
      return [];
    }
  }
}