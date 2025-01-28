import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoRepository extends ChangeNotifier {
  String nome = '';
  int qntPontos = 0;

  late FirebaseFirestore db = FirebaseFirestore.instance;
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  UserInfoRepository(){
    carregarQntPontos();
  }

  void adicionarPontos(int pontos){
    qntPontos += pontos;
    salvarQntPontos();
  }

  void removerPontos(int pontos){
    qntPontos -= pontos;
    salvarQntPontos();
  }

  void carregarQntPontos() async {
    try {
      DocumentSnapshot snapshot = await db.collection('users').doc(_auth.currentUser?.uid).get();
      final data = snapshot.data() as Map<String, dynamic>;
      qntPontos = data['qntPontos'] ?? 0;
    } catch (e) {
      print("Erro ao carregar quantidade de pontos do Firebase: $e");
    }
    notifyListeners();
  }

  void salvarQntPontos() async {
    try {
      await db.collection('users').doc(_auth.currentUser?.uid).set({
        'qntPontos': qntPontos,
      });
    } catch (e) {
      print("Erro ao salvar quantidade de pontos no Firebase: $e");
    }
    notifyListeners();
  }
}