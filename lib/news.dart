import 'package:flutter/material.dart';

import 'navBar.dart';

class News extends StatelessWidget {
  const News({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
          itemCount: 3,
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
            title: Text('News title'),
            subtitle: Text('Description'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Read more'),
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