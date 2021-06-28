class BookData {
  final String? id;
  final String title;
  final String filePath;
  final int position;
  final DateTime? readAt;

  const BookData({
    this.id,
    required this.title,
    required this.filePath,
    this.position = 0,
    this.readAt,
  });

  factory BookData.fromJson(Map<String, dynamic> json) => BookData(
        id: json['id'],
        title: json['title'],
        filePath: json['filePath'],
        position: json['position'],
        readAt: _dateTimeFromMilliseconds(json['readAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'filePath': filePath,
        'position': position,
        'readAt': readAt?.millisecondsSinceEpoch,
      };

  BookData copyWith({
    String? id,
    String? title,
    String? filePath,
    int? position,
    DateTime? readAt,
  }) =>
      BookData(
        id: id ?? this.id,
        title: title ?? this.title,
        filePath: filePath ?? this.filePath,
        position: position ?? this.position,
        readAt: readAt ?? this.readAt,
      );
}

DateTime? _dateTimeFromMilliseconds(int? milliseconds) => milliseconds != null
    ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
    : null;
