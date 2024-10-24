
class Review {
  late String id;
  late String? userId;
  late String? title;
  late String description;
  late double rating;
  late bool isReported;
  late DateTime createdAt;

  Review({
    required this.id,
    this.userId,
    this.title,
    required this.description,
    required this.rating,
    required this.isReported,
    required this.createdAt,
  });

  Review.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    title = json['title'];
    description = json['description'];
    rating = json['rating'].toDouble();
    isReported = json['isReported'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'rating': rating,
        'isReported': isReported,
        'createdAt': createdAt.toIso8601String(),
      };
}
