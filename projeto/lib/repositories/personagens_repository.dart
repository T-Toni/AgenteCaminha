import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/models/personagem.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto/services/auth_service.dart';

class PersonagensRepository extends ChangeNotifier {
  final List<Personagem> _lista = [
    Personagem(id: '1', nome: 'guerreiro', imagem: 'assets/bola1.png', posicao: 0),
    Personagem(id: '2', nome: 'curandeira', imagem: 'assets/bola2.png', posicao: 1),
    Personagem(id: '3', nome: 'mago', imagem: 'assets/mago.png', posicao: 2),
  ];

  late FirebaseFirestore db = FirebaseFirestore.instance;
  late FirebaseAuth _auth = FirebaseAuth.instance;

  UnmodifiableListView<Personagem> get lista => UnmodifiableListView(_lista);

  PersonagensRepository(){
    carregarPersonagens().then((personagens){
      List<Personagem> personagensToUpdate = [];
      for (Personagem personagem in personagens){
        var personagemLocal = lista.where((p) => p.id == personagem.id).first;
        personagemLocal.checado = personagem.checado;
        personagemLocal.posicao = personagem.posicao;
        personagensToUpdate.add(personagemLocal);
      }
      saveAll(personagensToUpdate); // VERIFICAR ID SEPA?
    });
    notifyListeners();
  }

  void _updateValuesPersonagem(Personagem personagemLocal, Personagem personagemDB){
    personagemLocal.checado = personagemDB.checado;
    personagemLocal.posicao = personagemDB.posicao;
  }

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
  Future<void> salvarPosicoesNoFirebase(List<Personagem> personagensEscolhidos) async {
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
      QuerySnapshot snapshot = await db.collection('personagens').get();

      List<Personagem> personagensCarregados = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Personagem(
          id: data['id'] ?? '',
          nome: data['nome'] ?? '',
          imagem: data['imagem'] ?? '',
          posicao: data['posicao'] ?? 0,
          checado: data['checado'] ?? false,
        );
      }).toList();
      return personagensCarregados;
    } catch (e) {
      print("Erro ao carregar personagens do Firebase: $e");
      return [];
    }
    
  }
}