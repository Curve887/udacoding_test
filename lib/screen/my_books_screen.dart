import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udacoding_test/models/my_book.dart';
import 'package:udacoding_test/provider/book_provider.dart';
import 'package:udacoding_test/screen/home_screen.dart';

class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  _MyBooksScreenState createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  late Future<List<MyBook>> futureMyBooks;

  @override
  void initState() {
    super.initState();
    futureMyBooks = fetchMyBooks();
  }

  Future<List<MyBook>> fetchMyBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final idLibrary = prefs.getString('id_library');
    final response = await http.get(Uri.parse(
        'http://localhost/api/index.php?action=my_books&id_library=$idLibrary'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> books = jsonResponse['books'];
      return books.map((book) => MyBook.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load my books');
    }
  }

  @override
  Widget build(BuildContext context) {
    var bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buku Saya'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigates to HomeScreen and replaces the current screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: FutureBuilder<List<MyBook>>(
        future: futureMyBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada buku'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final myBook = snapshot.data![index];
                return ListTile(
                  title: Text(myBook.bookTitle),
                  subtitle: Text(
                      'Pinjam: ${myBook.borrowDate} - Kembali: ${myBook.returnDate}'),
                  trailing: myBook.isBorrowed
                      ? ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final idLibrary = prefs.getString('id_library');
                            bookProvider.returnBook(
                                context, idLibrary, myBook.bookId);
                          },
                          child: const Text('Kembalikan'),
                        )
                      : const SizedBox(),
                );
              },
            );
          }
        },
      ),
    );
  }
}
