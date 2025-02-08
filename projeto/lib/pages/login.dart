import 'package:flutter/material.dart';
import 'package:projeto/pages/cadastro.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  login() async{
    try {
      await context.read<AuthService>().login(_emailController.text, _passwordController.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form (
            key : formKey,
            child : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Informe seu email!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Oculta a senha
                  validator: (value) {
                    if (value!.isEmpty){
                      return "Informe sua senha!";
                    }
                    else if (value.length < 6){
                      return "Sua senha deve ter no mínimo 6 caracteres";
                    }
                    return null;
                  }
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()){
                      login();
                    }
                  },
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navegar para a tela de cadastro
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SigninScreen()),
                    );
                  },
                  child: const Text('Não tem conta? Cadastre-se aqui!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}