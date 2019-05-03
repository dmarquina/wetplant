class Plant {
  int id;
  String name;
  String image;

  Plant({this.id, this.name, this.image});

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(id: json['id'], name: json['name'], image: json['image']);
  }
}
