import 'package:flutter/material.dart';
import 'package:prueba_mobx_y_supabase/pages/account/account_page.dart';
import 'package:prueba_mobx_y_supabase/pages/home/home_page.dart';
import 'package:prueba_mobx_y_supabase/pages/login/login_page.dart';
import 'package:prueba_mobx_y_supabase/pages/register/register_page.dart';
import 'package:prueba_mobx_y_supabase/pages/splash/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://uhglkcduvmgegowomnyx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVoZ2xrY2R1dm1nZWdvd29tbnl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE2NzYxNzEsImV4cCI6MjAyNzI1MjE3MX0.Q7m6cjYuEuF65ZHXGnx5DRK12_ji_N-axCXzP-GIM_w',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/splash': (context) => SplashPage(),
          '/login': (context) => LoginPage(),
          '/account': (context) => AccountPage(),
          '/register': (context) => RegisterForm(),
          '/home': (context) => HomePage(),
        });
  }
}
