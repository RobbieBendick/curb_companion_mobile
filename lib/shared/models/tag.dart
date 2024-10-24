import 'package:curb_companion/shared/models/profile_image.dart';

class Tag {
  String id;
  String title;
  CCImage? image;
  bool active = false;

  Tag({required this.id, required this.title, required this.image});

  Tag.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        image = json['image'] != null ? CCImage.fromJson(json['image']) : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image?.toJson(),
    };
  }
}
