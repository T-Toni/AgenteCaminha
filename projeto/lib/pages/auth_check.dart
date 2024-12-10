import 'package:flutter/material.dart';
import 'package:projeto/pages/menu.dart';
import 'package:projeto/pages/login.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck>{


  @override
  Widget build(BuildContext context) {

    AuthService auth = Provider.of<AuthService>(context);
    
    if (auth.isLoading){
      return loading();
    }
    else if (auth.usuario == null){
      return LoginScreen();
    }
    else{
      return Menu();
    }
  }
  
  loading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator()),
    );
  }
}