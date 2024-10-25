import 'package:flutter/material.dart';
import 'package:projeto/pages/home.dart';
import 'package:projeto/pages/luta.dart';
import 'package:projeto/pages/personagens_lista.dart';


class Menu extends StatefulWidget {
  const Menu({super.key, required this.title});

  final String title;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onConfigTapped() {
    setState(() {
      //print("sa");
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Personagens(),
    Home(title: 'Home'),
    Luta(title: 'Luta'),
  ];
  
  @override
  Widget build(BuildContext context) {

    return Scaffold( //tela
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [IconButton(onPressed: _onConfigTapped, icon: const Icon(Icons.settings))],
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color.fromARGB(255, 24, 59, 92),
            fontSize: 20.0
            ),
          ), //tipo um this
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,   
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.backpack),
            label: 'Personagens',
            backgroundColor: Color.fromARGB(255, 24, 59, 92),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color.fromARGB(255, 24, 59, 92),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Luta',
            backgroundColor: Color.fromARGB(255, 24, 59, 92),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 24, 59, 92),
        onTap: _onItemTapped,
      ),
    
    );
  }
}
