class CCImage {
  String name;
  String imageURL;
  String owner;
  String ownerType;
  String uploader;
  DateTime uploadedAt;

  CCImage(
      {required this.name,
      required this.imageURL,
      required this.owner,
      required this.ownerType,
      required this.uploader,
      required this.uploadedAt});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageURL': imageURL,
      'owner': owner,
      'ownerType': ownerType,
      'uploader': uploader,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  factory CCImage.fromJson(Map<String, dynamic> json) {
    return CCImage(
      name: json['name'],
      imageURL: json['imageURL'],
      owner: json['owner'],
      ownerType: json['ownerType'],
      uploader: json['uploader'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
    );
  }
}
