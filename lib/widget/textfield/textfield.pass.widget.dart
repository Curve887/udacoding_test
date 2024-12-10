import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udacoding_test/provider/auth_provider.dart';

class TexfieldPasswordWidget extends StatefulWidget {
  const TexfieldPasswordWidget({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<TexfieldPasswordWidget> createState() => _TexfieldPasswordWidgetState();
}

class _TexfieldPasswordWidgetState extends State<TexfieldPasswordWidget> {
  bool obscureText = true; // Tambahkan titik koma di sini
  @override
  Widget build(BuildContext context) {
    var loadAuth = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscureText,
          validator: (value) {
            // Tambahkan 'validator' di sini
            if (value!.trim().isEmpty || value == "") {
              return "Password can't be empty";
            } else if (value.trim().length < 6) {
              return "Password should more than 6 character";
            }
            return null;
          },
          onSaved: (value) {
            loadAuth.enteredPassword = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Insert Password....",
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: const Icon(Icons.remove_red_eye_rounded))),
        ),
      ],
    );
  }
}
