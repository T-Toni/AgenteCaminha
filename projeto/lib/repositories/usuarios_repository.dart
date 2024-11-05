import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:projeto/models/usuario.dart';

class UsuariosRepository extends ChangeNotifier{
  final List<Usuario>_lista = [
      Usuario(nome: 'João', login: "joao", senha: "123"),
      Usuario(nome: 'Antônio', login: "antonio", senha: "123"),
      Usuario(nome: 'Pedro', login: "pedro", senha: "123"),
    ];
  late Usuario userLoggedIn;

  UnmodifiableListView<Usuario> get lista => UnmodifiableListView(_lista);


  remove(Usuario usuario){
    _lista.remove(usuario);
    notifyListeners();
  }

  bool save(String nome, String login, String senha) {

      for (var usuario in _lista){
        if (usuario.login == login){
          return false;
        }
      }
      
      Usuario novo_usuario = Usuario(nome: nome, login: login, senha: senha);
      
      _lista.add(novo_usuario);
      notifyListeners();
      
      return true;
  }

  bool validaUsuario(String login, String senha){

    for (var usuario in _lista){
      if (usuario.login == login && usuario.senha == senha){
        userLoggedIn = usuario;
        return true;
      }
    }

    return false;
  }
}