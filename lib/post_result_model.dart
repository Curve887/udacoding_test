import 'dart:convert';
import 'package:http/http.dart' as http;

class PostResult {
  final String name;
  final String email;
  final String alamat;
  final String password;
  final String levelId;

  PostResult({
    required this.name,
    required this.email,
    required this.alamat,
    required this.password,
    required this.levelId,
  });

  // Factory untuk membuat instance dari response API
  factory PostResult.createPostResult(Map<String, dynamic> object) {
    return PostResult(
      name: object['name'] ?? '',
      email: object['email'] ?? '',
      alamat: object['alamat'] ?? '',
      password: object['password'] ?? '',
      levelId: object['level_id'] ?? '',
    );
  }

  // Metode untuk melakukan POST request ke API

  static Future<PostResult> connectToApi({
    required String name,
    required String email,
    required String alamat,
    required String password,
    required String levelId,
  }) async {
    const String apiUrl = "http://localhost/api/index.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'alamat': alamat,
          'password': password,
          'level_id': levelId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic>) {
          return PostResult.createPostResult(data);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to connect to API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during API request: $e');
    }
  }
}
