class Comment {
  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
    required this.likes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] as String,
        author: json['author'] as String,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        likes: json['likes'] as int,
      );

  final String id;
  final String author;
  final String text;
  final DateTime createdAt;
  final int likes;
}

class Photo {
  Photo({
    required this.id,
    required this.title,
    required this.author,
    required this.asset,
    required this.takenAt,
    required this.likes,
    required this.tags,
    required this.comments,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json['id'] as int,
        title: json['title'] as String,
        author: json['author'] as String,
        asset: json['asset'] as String,
        takenAt: DateTime.parse(json['takenAt'] as String),
        likes: json['likes'] as int,
        tags: (json['tags'] as List<dynamic>).cast<String>(),
        comments: (json['comments'] as List<dynamic>)
            .map((c) => Comment.fromJson(c as Map<String, dynamic>))
            .toList(),
      );

  final int id;
  final String title;
  final String author;
  final String asset;
  final DateTime takenAt;
  final int likes;
  final List<String> tags;
  final List<Comment> comments;
}
