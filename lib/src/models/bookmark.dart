class Bookmark {
  final String? id;
  final String text;
  final List<String> tags;
  final String path;
  final String title;
  final int position;
  final String bookId;

  const Bookmark({
    this.id,
    required this.position,
    required this.text,
    required this.tags,
    required this.title,
    required this.path,
    required this.bookId,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        id: json['id'],
        position: json['position'],
        text: json['text'],
        tags: json['tags'].cast<String>(),
        path: json['path'],
        title: json['title'],
        bookId: json['bookId'],
      );

  Bookmark copyWith({
    String? id,
    int? position,
    String? text,
    List<String>? tags,
    String? path,
    String? title,
    String? bookId,
  }) =>
      Bookmark(
        id: id ?? this.id,
        position: position ?? this.position,
        text: text ?? this.text,
        tags: tags ?? this.tags,
        path: path ?? this.path,
        title: title ?? this.title,
        bookId: bookId ?? this.bookId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'position': position,
        'text': text,
        'tags': tags,
        'path': path,
        'title': title,
        'bookId': bookId,
      };
}
