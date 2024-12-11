import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:udacoding_test/screen/my_books_screen.dart';

class BookProvider with ChangeNotifier {
  final String enpoint = 'http://localhost/api/index.php';
  void borrowBook(BuildContext context, String idLibrary, int bookId,
      String bookTitle, DateTime borrowDate, DateTime returnDate) async {
    final url = Uri.parse(enpoint);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'action': 'borrow',
        'id_library': idLibrary,
        'book_id': bookId,
        'book_title': bookTitle,
        'borrow_date': borrowDate.toIso8601String(),
        'return_date': returnDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      if (!context.mounted) return;
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil meminjam buku'),
        ),
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MyBooksScreen()));
    } else {
      // Handle error
      final responseBody = json.decode(response.body);
      final message = responseBody['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal meminjam buku. Alasan: $message'),
        ),
      );
      throw Exception('Failed to borrow book');
    }
  }

  void returnBook(BuildContext context, String? idLibrary, int bookId) async {
    final url = Uri.parse(enpoint);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'action': 'return',
        'id_library': idLibrary,
        'book_id': bookId,
      }),
    );
    if (response.statusCode == 200) {
      if (!context.mounted) return;
      // Handle success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil mengembalikan buku'),
        ),
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MyBooksScreen()));
    }
  }
}
