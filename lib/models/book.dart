class Book {
  final int id;
  final int year;
  final String title;
  final String publisher;
  final String author = "Stephen King";
  final int pages;
  final String createdAt;
  final List<String> notes;
  final String isbn;

  Book({
    required this.id,
    required this.year,
    required this.title,
    required this.publisher,
    required this.pages,
    required this.createdAt,
    required this.notes,
    required this.isbn,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      year: json['Year'],
      title: json['Title'],
      publisher: json['Publisher'],
      isbn: json['ISBN'],
      pages: json['Pages'],
      createdAt: json['created_at'],
      notes: List<String>.from(json['Notes']),
    );
  }
}