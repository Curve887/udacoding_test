class MyBook {
  final String idLibrary;
  final int bookId;
  final String  bookTitle;
  final String borrowDate;
  final String returnDate;
  final bool isBorrowed;


  MyBook({
    required this.idLibrary,
    required this.bookId,
    required this.bookTitle,
    required this.borrowDate,
    required this.returnDate,
    required this.isBorrowed,
  });

  factory MyBook.fromJson(Map<String, dynamic> json) {
    return MyBook(
      idLibrary: json['id_library'],
      bookId: json['book_id'],
      bookTitle: json['book_title'],
      borrowDate: json['borrow_date'],
      returnDate: json['return_date'],
      isBorrowed: json['is_borrowed'],
    );
  }
}