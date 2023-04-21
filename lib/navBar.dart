import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kiinteistohuolto/mainMenu.dart';
import './news.dart';
import './settings.dart';
import './orderHistory.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final CollectionReference _services =
      FirebaseFirestore.instance.collection('News');
  int _selectedIndex = 0;
  final List<String> menuTitle = [
    "Main menu",
    "Order history/Status",
    "News",
    "Settings"
  ];
  
  final List<Widget> _widgetOptions = <Widget>[
    const Scaffold(body: MainMenu()),
    Scaffold(body: const OrderHistoryy()),
    const Scaffold(body: News()),
    Scaffold(body: SettingsClass())
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(menuTitle[_selectedIndex]), actions: [
          if (_selectedIndex == 2)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _addCard,
            ),
        ],),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Services',
              backgroundColor: Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Order history/status',
              backgroundColor: Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'News',
              backgroundColor: Colors.grey,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              backgroundColor: Colors.grey,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ));
  }

void _addCard() {
    _services.add({
      'title': 'New card title',
      'description': 'New card description',
      'timestamp': Timestamp.now(),
    });
  }

}
