import 'package:flutter/material.dart';
import 'package:projeto/menu.dart';
import 'package:projeto/pages/cadastro.dart';
import 'package:projeto/repositories/usuarios_repository.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late UsuariosRepository usuarios;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    usuarios = context.watch<UsuariosRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Oculta a senha
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Captura os valores dos campos de texto
                String username = _usernameController.text;
                String password = _passwordController.text;

                if (username == ""|| password == "") 
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Preencha todos os campos.')),
                  );
                }
                else
                {
                  // Verificar se o login existe
                  bool sucesso = usuarios.validaUsuario(username, password);

                  if (sucesso){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Menu(title: 'AgenteCaminha')), // tira a tela de login e substitui pela tela do jogo em si
                    );
                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login falhou! Tente novamente.')),
                    );
                  }
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
    );
  }
}