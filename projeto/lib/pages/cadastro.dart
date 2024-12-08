import 'package:flutter/material.dart';
import 'package:projeto/repositories/usuario_repository';
import 'package:provider/provider.dart';

class SigninScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late UsuariosRepository usuarios;

  SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    usuarios = context.watch<UsuariosRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
                String name = _nameController.text;
                String username = _usernameController.text;
                String password = _passwordController.text;

                //confere se todos os campos foram preenchidos
                if (name == '' || username == "" || password == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Preencha todos os campos.')), //apresenta o aviso
                  );
                } else {
                  //cadastra um novo usuário
                  bool sucesso = usuarios.save(name, username,
                      password); //salva o novo usuario ou avisa que ja existe

                  if (sucesso) {
                    Navigator.pop(context); //retorna para a tela anterior
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Usuário ja cadastrado! Tente novamente.')), //avisa que ja existe um usuário
                    );
                  }
                }
              },
              child: const Text('Cadastrar'),
            )
          ],
        ),
      ),
    );
  }
}
