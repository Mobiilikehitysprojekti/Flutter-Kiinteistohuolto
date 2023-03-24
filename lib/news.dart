import 'package:flutter/material.dart';
import 'navBar.dart';

class News extends StatefulWidget {
  const News({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  int _cardCount = 3;
  bool isAdmin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
        itemCount: _cardCount,
        itemBuilder: (context, index) {
          return MenuCard();
        },
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _cardCount++;
                });
              },
            )
          : null,
    );
  }
}

class MenuCard extends StatefulWidget {
  const MenuCard({Key? key}) : super(key: key);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool isExpanded = false;

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
          if (isExpanded)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('More details'),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: Text(isExpanded ? 'Close' : 'Read more'),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
