import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_kiinteistohuolto/theme_constants.dart';
import 'package:flutter_kiinteistohuolto/utils.dart';
import 'package:flutter_kiinteistohuolto/theme_manager.dart';
import 'admin.dart';

import './signIn.dart';
import './settings.dart';
import './navBar.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Admin.isAdmin();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();
Settings theme = Settings();
ThemeManager _themeManager = theme.getThememode();

class MyApp extends StatefulWidget {
  @override
  MyAppPage createState() => MyAppPage();
}

class MyAppPage extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
        home: const MainPage(),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else if (snapshot.hasData) {
              return const Scaffold(
                body: NavBar(),
              );
            } else {
              return const Signin();
            }
          },
        ),
      );
}
