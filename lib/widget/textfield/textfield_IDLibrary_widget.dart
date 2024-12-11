import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:udacoding_test/provider/auth_provider.dart';

class TextfieldIDLibraryWidget extends StatefulWidget {
  const TextfieldIDLibraryWidget({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<TextfieldIDLibraryWidget> createState() =>
      _TextfieldIDLibraryWidgetState();
}

class _TextfieldIDLibraryWidgetState extends State<TextfieldIDLibraryWidget> {
  @override
  Widget build(BuildContext context) {
    var loadAuth = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ID Library",
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
              return "ID Library can't be empty";
            }
            return null;
          },
          onSaved: (value) {
            loadAuth.enteredIDLibrary = value!;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: "Insert ID Library...",
          ),
        ),
      ],
    );
  }
}
