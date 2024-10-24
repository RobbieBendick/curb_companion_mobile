class Notification {
  late String id;
  late String? title;
  late String body;
  late String age;
  late String userId;
  late String route;
  late bool read;
  late DateTime createdAt;

  Notification({
    required this.id,
    this.title,
    required this.body,
    required this.age,
    required this.userId,
    required this.read,
    required this.route,
    required this.createdAt,
  });

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    userId = json['userId'];
    age = json['age'];
    read = json['read'];
    route = json['route'];
    createdAt = DateTime.parse(json['createdAt']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'userId': userId,
        'age': age,
        'read': read,
        'route': route,
        'createdAt': createdAt.toIso8601String(),
      };
}
