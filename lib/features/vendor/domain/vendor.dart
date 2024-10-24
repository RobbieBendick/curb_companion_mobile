// ignore_for_file: prefer_if_null_operators

import 'package:curb_companion/features/vendor/domain/menu_item.dart';
import 'package:curb_companion/shared/models/profile_image.dart';
import 'package:curb_companion/features/review/domain/review.dart';
import 'package:curb_companion/features/location/domain/cc_location.dart';
import 'package:hive/hive.dart';

class Vendor extends HiveObject {
  late String id;
  late String title;
  late String? ownerId;
  late String? email;
  late String? description;
  late CCLocation? location;
  late String? phoneNumber;
  late String? website;
  late int views;
  late List<String> tags;
  late List<Review> reviews;
  late double rating;
  late CCImage? profileImage;
  late List<CCImage> images;
  late List<dynamic> schedule;
  late List<MenuItem> menu;
  late List<dynamic> live;
  late List<dynamic> liveHistory;
  late bool isCatering;
  late bool isOpen;
  late double? distance;

  Vendor({
    required this.id,
    required this.title,
    this.ownerId,
    this.email,
    this.description,
    this.location,
    required this.images,
    this.phoneNumber,
    this.website,
    required this.views,
    required this.tags,
    required this.reviews,
    required this.rating,
    this.profileImage,
    required this.schedule,
    required this.menu,
    required this.live,
    required this.liveHistory,
    required this.isCatering,
    required this.isOpen,
    this.distance,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    ownerId = json['ownerId'];
    email = json['email'];
    description = json['description'];
    images = List<CCImage>.from(json['images'].map((imageJson) =>
        {imageJson != null ? CCImage.fromJson(imageJson) : null}));
    location =
        json['location'] != null ? CCLocation.fromJson(json['location']) : null;
    phoneNumber = json['phoneNumber'];
    website = json['website'];
    views = json['views'];
    tags = json['tags'] != null
        ? List<String>.from(json['tags'].map((tagsJson) => tagsJson['title']))
        : [];
    reviews = json['reviews'] != null
        ? List<Review>.from(
            json['reviews'].map((reviewJson) => Review.fromJson(reviewJson)))
        : [];
    rating = json['rating']?.toDouble();
    profileImage = json['profileImage'] != null
        ? CCImage.fromJson(json['profileImage'])
        : null;
    schedule =
        json['schedule'] != null ? List<dynamic>.from(json['schedule']) : [];
    menu = json['menu'] != null
        ? List<MenuItem>.from(
            json['menu'].map((menuItemJson) => MenuItem.fromJson(menuItemJson)))
        : [];
    live = List<dynamic>.from(json['live']);
    liveHistory = List<dynamic>.from(json['liveHistory']);
    isCatering = json['isCatering'];
    isOpen = json['isOpen'] != null ? json['isOpen'] : false;
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'ownerId': ownerId,
        'email': email,
        'description': description,
        'location': location?.toJson(),
        'phoneNumber': phoneNumber,
        'website': website,
        'views': views,
        'tags': tags,
        'rating': rating,
        'reviews': reviews.map((e) => e.toJson()).toList(),
        'images': images.map((e) => e.toJson()).toList(),
        'profileImage': profileImage?.toJson(),
        'schedule': schedule,
        'menu': menu.map((e) => e.toJson()).toList(),
        'live': live,
        'liveHistory': liveHistory,
        'isCatering': isCatering,
        'isOpen': isOpen,
        'distance': distance,
      };
}
