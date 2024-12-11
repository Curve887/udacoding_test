import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:udacoding_test/models/book.dart'; // Adjust the import path
import 'package:udacoding_test/screen/book_detail_screen.dart';
import 'package:udacoding_test/screen/my_books_screen.dart'; // Adjust the import path
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udacoding_test/screen/login_screen.dart'; // Import the LoginScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<List<Book>> fetchPosts() async {
    final response = await http
        .get(Uri.parse('https://stephen-king-api.onrender.com/api/books'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all session data

    // Navigate to LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stephen King Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () {
              // Handle my books button press
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening My Books')),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyBooksScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // Logout when pressed
          ),
        ],
      ),
      body: FutureBuilder<List<Book>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.year.toString()),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle borrow button press
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening Book: ${book.title}')),
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BookDetailScreen(bookId: book.id)));
                    },
                    child: const Text('Pinjam'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
