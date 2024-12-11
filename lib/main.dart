import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udacoding_test/provider/auth_provider.dart';
import 'package:udacoding_test/provider/book_provider.dart';
import 'package:udacoding_test/provider/imagepick_provider.dart';
import 'package:udacoding_test/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ImagePickProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        darkTheme: ThemeData(
          brightness: Brightness.dark, // Koma ditambahkan di sini
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.dark,
        home: const LoginScreen(),
      ),
    );
  }
}
