import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:projeto/models/usuario.dart';

class UsuariosRepository extends ChangeNotifier{
  final List<Usuario>_lista = [
      Usuario(nome: 'toni', login: "antonio", senha: "antonio"),
      Usuario(nome: 'peido', login: "pedro", senha: "pedro"),
    ];

  UnmodifiableListView<Usuario> get lista => UnmodifiableListView(_lista);

  remove(Usuario Usuario){
    _lista.remove(Usuario);
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

    bool existe = false;

    for (var usuario in _lista){
      if (usuario.login != login || usuario.senha != senha){
      }
      else{
        existe = true;
      }
    }

    return existe;
  }
}