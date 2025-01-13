import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projeto/pages/home.dart';
import 'package:projeto/pages/luta.dart';
import 'package:projeto/pages/personagens_lista.dart';
import 'package:projeto/services/auth_service.dart';
import 'package:provider/provider.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 1;
  final ValueNotifier<bool> caminhandoNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }
  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Serviço de Localização Desativado'),
          content: Text('Por favor, ative o serviço de localização para usar este aplicativo.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }
  
  void _onItemTapped(int index) {
    if (!caminhandoNotifier.value) {
      setState(() {
        _selectedIndex = index;
      });
    }
    else{
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar(content: Text('Oi $nomeUsuario, suas configurações ainda não foram liberadas!')),
        SnackBar(content: Text('Termine a sua caminhada para trocar de tela.')),
      );
    }
  }

  void _onConfigTapped() {
    setState(() {
      context.read<AuthService>().logout();
      //String nomeUsuario = usuarios.userLoggedIn.nome;
      ScaffoldMessenger.of(context).showSnackBar(
        //SnackBar(content: Text('Oi $nomeUsuario, suas configurações ainda não foram liberadas!')),
        SnackBar(content: Text('Logout com sucesso.')),
      );
    });
  }

  static List<Widget>  _widgetOptions(ValueNotifier<bool> caminhandoNotifier) => <Widget>[
    const Personagens(),
    Home(caminhandoNotifier: caminhandoNotifier),
    const Luta(),
  ];
  
  @override
  Widget build(BuildContext context) {
    //usuarios = context.watch<UsuariosRepository>();
    return Scaffold( //tela
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(onPressed: _onConfigTapped, icon: const Icon(Icons.logout))],
        title: Text(
          "AgenteCaminha",
          style: const TextStyle(
            //color: Color.fromARGB(255, 24, 59, 92),
            fontSize: 20.0
            ),
          ), //tipo um this
      ),
      body: Center(
        child: _widgetOptions(caminhandoNotifier).elementAt(_selectedIndex),
      ),
      
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,   
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: caminhandoNotifier,
        builder: (context, caminhando, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.backpack),
                label: 'Personagens',
                //backgroundColor: Color.fromARGB(255, 24, 59, 92),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                //backgroundColor: Color.fromARGB(255, 24, 59, 92),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.handshake),
                label: 'Luta',
                //backgroundColor: Color.fromARGB(255, 24, 59, 92),
              ),
            ],
            currentIndex: _selectedIndex,
            //selectedItemColor: const Color.fromARGB(255, 24, 59, 92),
            onTap: _onItemTapped,
            type: caminhando ? BottomNavigationBarType.shifting : BottomNavigationBarType.fixed,
          );
        },
      ),
    );
  }
}
