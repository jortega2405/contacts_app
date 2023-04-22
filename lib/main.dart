import 'package:contacts_app/src/screens/login_screen.dart';
import 'package:contacts_app/src/screens/register_screen.dart';
import 'package:contacts_app/src/themes/dark_theme.dart';
import 'package:contacts_app/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized;

  await Supabase.initialize(
    url: url,
    anonKey: anonKey
  );
  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Material App',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          
            '/'       :(context) => const LoginScreen(),
          'register':(context) => const RegisterScreen()
        },
      );
  }
}

