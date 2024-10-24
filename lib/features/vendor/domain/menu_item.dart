// ignore_for_file: prefer_if_null_operators, prefer_null_aware_operators

import 'package:curb_companion/shared/models/profile_image.dart';

class MenuItem {
  final String title;
  final String? description;
  final double? price;
  final String type;
  final CCImage? image;

  MenuItem({
    required this.title,
    this.description,
    this.price,
    required this.type,
    this.image,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json["title"],
      description: json["description"] != null ? json["description"] : null,
      price: json["price"] != null ? json["price"]?.toDouble() : null,
      type: json["type"],
      image: json['image'] != null ? CCImage.fromJson(json['image']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "price": price,
        "type": type,
        "image": image?.toJson(),
      };
}
