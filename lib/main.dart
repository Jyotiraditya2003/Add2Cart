import 'package:add2cart/screens/list_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/sign_up_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/home_screen.dart';
import 'screens/create_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add2Cart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(), // Set SignUpScreen as the home screen
      routes: {
        '/signin': (context) => SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/createlist' : (context) => CreateListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/items') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ListItemsScreen(
              listName: args['listName'],
              items: args['items'],
            ),
          );
        }
        return null;
      },
    );
  }
}