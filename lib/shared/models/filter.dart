class Filter {
  String? id;
  String? title;
  String? iconName;
  bool active = false;

  Filter({this.id, this.title, this.iconName});

  Filter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    iconName = json['iconName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'iconName': iconName,
      'active': active,
    };
  }
}
