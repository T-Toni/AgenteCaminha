import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception{
  String message;

  AuthException(this.message);
}

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  User? usuario;
  bool isLoading = true;

  AuthService(){
    _authCheck();
  }

  _authCheck(){
    _auth.authStateChanges().listen((User? user){
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser(){
    usuario = _auth.currentUser;
    notifyListeners();
  }

  _loading(){
    isLoading = true;
    notifyListeners();
  }

  _loaded(){
    isLoading = false;
    notifyListeners();
  }

  registrar(String nome, String email, String senha) async {
    _loading();
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);
      _getUser();
      await salvarInformacoes(nome, email);
    } on FirebaseAuthException catch (e){
      if (e.code == 'weak-password'){
        throw AuthException('A senha é muito fraca');
      } else if (e.code == 'email-already-in-use'){
        throw AuthException('Este email já esta cadastrado');
      }
    }
    _loaded();
  }

  login(String email, String senha) async {
    _loading();
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found'){
        throw AuthException('Email não encontrado. Cadastre-se');
      } else if (e.code == 'wrong-password'){
        throw AuthException('Senha incorreta. Tente novamente');
      }
    }
    _loaded();
  }

  logout() async{
    _loading();
    await _auth.signOut();
    _getUser();
    _loaded();
  }

  Future<void> salvarInformacoes(String name, String email) async {
    try {
      WriteBatch batch = db.batch();
      CollectionReference personagensRef = db.collection('users');

      DocumentReference docRef = personagensRef.doc(usuario?.uid);
      batch.set(docRef, {
        'nome': name,
        'email': email
      });

      await batch.commit();
    } catch (e) {
      print("Erro ao salvar posições no Firebase: $e");
    }
  }

  String? getCurrentUserID(){
    return usuario?.uid;
  }

}