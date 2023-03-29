import 'package:flutter/material.dart';
import 'navBar.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MainMenu extends StatelessWidget {
  const MainMenu({super.key, required this.title, required this.navbar});

  final String title;
  final Widget navbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return  MenuCard();
          }),
          bottomNavigationBar: navbar,
    );
  }
}

class MenuCard extends StatelessWidget {
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
