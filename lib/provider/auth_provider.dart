import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:udacoding_test/screen/home_screen.dart';
import 'package:udacoding_test/screen/welcome_screen.dart';

class AuthProvider extends ChangeNotifier {
  final form = GlobalKey<FormState>();

  var islogin = true;
  var enteredEmail = '';
  var enteredPassword = '';
  var enteredIDLibrary = '';
  var enteredNama = '';
  var idLibrary = '';
  var endpoint = 'http://localhost/api/index.php';

  void submit(BuildContext context) async {
    final isvalid = form.currentState!.validate();

    if (!isvalid) {
      return;
    }
    form.currentState!.save();
    final url = Uri.parse(endpoint);
    final response = await http.post(
      url,
      body: json.encode({
        'email': enteredEmail,
        'password': enteredPassword,
        'name': enteredNama,
        'action': islogin ? 'login' : 'register',
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (!context.mounted) return;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      var idLibrary = responseData['id_library'];
      ScaffoldMessenger.of(form.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Success'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomeScreen(idLibrary: idLibrary),
        ),
      );
    } else {
      ScaffoldMessenger.of(form.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Failed'),
        ),
      );
    }
  }

  void login(BuildContext context) async {
    form.currentState!.save();
    final url = Uri.parse(endpoint);
    final response = await http.post(
      url,
      body: json.encode({
        'id_library': enteredIDLibrary,
        'password': enteredPassword,
        'action': 'login',
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final sessionId = responseData['session_id'];
      final idLibrary = responseData['id_library'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_id', sessionId);
      await prefs.setString('id_library', idLibrary);
      ScaffoldMessenger.of(form.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Success'),
        ),
      );
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      final responseData = json.decode(response.body);
      final message = responseData['message'];
      ScaffoldMessenger.of(form.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Failed: $message'),
        ),
      );
    }
  }
}
