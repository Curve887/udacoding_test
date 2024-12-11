import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udacoding_test/models/book.dart';
import 'package:udacoding_test/models/my_book.dart';
import 'package:udacoding_test/provider/book_provider.dart';
import 'package:udacoding_test/widget/textfield/textfield_date_widget.dart';

class BookDetailScreen extends StatefulWidget {
  final int bookId;
  const BookDetailScreen({super.key, required this.bookId});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<Book> futureBook;
  late Future<MyBook> futureMyBook;
  DateTime? borrowDate;
  DateTime? returnDate;
  final endpoint = 'http://localhost/api/index.php';

  @override
  void initState() {
    super.initState();
    futureBook = fetchBookDetails(widget.bookId);
    futureMyBook = fetchMyBook(widget.bookId);
  }

  Future<Book> fetchBookDetails(int id) async {
    final response = await http
        .get(Uri.parse('https://stephen-king-api.onrender.com/api/book/$id'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return Book.fromJson(responseBody['data']);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  Future<MyBook> fetchMyBook(int id) async {
    final response =
        await http.get(Uri.parse('$endpoint?action=is_borrowed&book_id=$id'));
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return MyBook.fromJson(responseBody);
    } else {
      throw Exception('Failed to load my book');
    }
  }

  @override
  Widget build(BuildContext context) {
    var bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Detail'),
      ),
      body: FutureBuilder<Book>(
        future: futureBook,
        builder: (context, bookSnapshot) {
          if (bookSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (bookSnapshot.hasError) {
            return Center(child: Text('Error: ${bookSnapshot.error}'));
          } else if (!bookSnapshot.hasData) {
            return const Center(child: Text('No book found'));
          } else {
            Book book = bookSnapshot.data!;
            return FutureBuilder<MyBook>(
              future: futureMyBook,
              builder: (context, myBookSnapshot) {
                if (myBookSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (myBookSnapshot.hasError) {
                  return Center(child: Text('Error: ${myBookSnapshot.error}'));
                } else if (!myBookSnapshot.hasData) {
                  return const Center(child: Text('No data found'));
                } else {
                  MyBook myBook = myBookSnapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Author: ${book.author}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Published: ${book.year}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ISBN: ${book.isbn}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pages: ${book.pages}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Notes: ${book.notes.join(', ')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        if (!myBook.isBorrowed) ...[
                          const Text('Tanggal Pinjam',
                              style: TextStyle(fontSize: 16)),
                          DatePickerWidget(
                            onDateSelected: (date) {
                              setState(() {
                                borrowDate = date;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          const Text('Tanggal Kembali',
                              style: TextStyle(fontSize: 16)),
                          DatePickerWidget(
                            onDateSelected: (date) {
                              setState(() {
                                returnDate = date;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              if (borrowDate != null && returnDate != null) {
                                try {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final idLibrary =
                                      prefs.getString('id_library');
                                  bookProvider.borrowBook(
                                      context,
                                      idLibrary!,
                                      book.id,
                                      book.title,
                                      borrowDate!,
                                      returnDate!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Meminjam Buku: ${book.title}')),
                                  );
                                } catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Failed to borrow book')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please select both dates')),
                                );
                              }
                            },
                            child: const Text('Pinjam'),
                          ),
                        ] else ...[
                          const Text('Buku ini telah dipinjam.',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
