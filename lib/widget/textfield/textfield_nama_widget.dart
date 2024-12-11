import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udacoding_test/provider/auth_provider.dart';

class TextfieldNamaWidget extends StatefulWidget {
  const TextfieldNamaWidget({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<TextfieldNamaWidget> createState() => _TextfieldNamaWidgetState();
}

class _TextfieldNamaWidgetState extends State<TextfieldNamaWidget> {
  @override
  Widget build(BuildContext context) {
    var loadAuth = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nama",
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
              return "Nama can't be empty";
            }
            return null;
          },
          onSaved: (value) {
            loadAuth.enteredNama = value!;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: "Insert Nama...",
          ),
        ),
      ],
    );
  }
}