import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udacoding_test/provider/auth_provider.dart';

class TexfieldEmailWidget extends StatefulWidget {
  const TexfieldEmailWidget({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<TexfieldEmailWidget> createState() => _TexfieldEmailWidgetState();
}

class _TexfieldEmailWidgetState extends State<TexfieldEmailWidget> {
  @override
  Widget build(BuildContext context) {
    var loadAuth = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty || value == "") {
              return "Email can't be empty";
            } else if (!value.trim().contains("@")) {
              return "Email not valid";
            }
            return null;
          },
          onSaved: (value) {
            loadAuth.enteredEmail = value!;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: "Insert Email...."),
        )
      ],
    );
  }
}
