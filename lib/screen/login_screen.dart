import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udacoding_test/provider/auth_provider.dart';
import 'package:udacoding_test/widget/imgpick/imagepick_widget.dart';
import 'package:udacoding_test/widget/textfield/texfield_email_widget.dart';
import 'package:udacoding_test/widget/textfield/textfield.pass.widget.dart';
import 'package:udacoding_test/widget/textfield/textfield_nama_widget.dart';
import 'package:udacoding_test/widget/textfield/textfield_idlibrary_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udacoding_test/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController idLibrary = TextEditingController();

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    if (sessionId != null) {
      // Navigate to HomeScreen if session ID is found
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var loadAuth = Provider.of<AuthProvider>(context);

    return Container(
      color: const Color.fromARGB(255, 29, 29, 29),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset:
              true, // Memastikan keyboard tidak menutupi form
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/dark_pattern.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loadAuth.islogin ? "Login" : "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.headlineLarge?.fontSize,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.green,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Form(
                        key: loadAuth.form,
                        child: Column(
                          children: [
                            if (!loadAuth.islogin) ...[
                              const ImagePickWidget(),
                              const SizedBox(height: 15),
                              TextfieldNamaWidget(controller: name),
                              const SizedBox(height: 15),
                              TexfieldEmailWidget(controller: email),
                              const SizedBox(height: 15),
                            ],
                            if (loadAuth.islogin)
                              TextfieldIDLibraryWidget(controller: idLibrary),
                            const SizedBox(height: 15),
                            TexfieldPasswordWidget(controller: password),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (loadAuth.islogin) {
                                    loadAuth.login(context);
                                  } else {
                                    loadAuth.submit(context);
                                  }
                                },
                                child: Text(
                                    loadAuth.islogin ? "Login" : "Register"),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  loadAuth.islogin = !loadAuth.islogin;
                                });
                              },
                              child: Text(loadAuth.islogin
                                  ? "Create account"
                                  : "I already have account"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 30), // Ruang tambahan agar form tidak tertutup
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
