import 'package:flutter/material.dart';

import 'navBar.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return const MenuCard();
          }),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  final cardAmount = 3;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            title: Text('Service 1'),
            subtitle: Text('Price'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('About'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Order'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
