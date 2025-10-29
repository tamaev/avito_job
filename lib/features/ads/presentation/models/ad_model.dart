class AdModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final int price;
  final String location;
  final String seller;

  AdModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.seller,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'price': price,
    'location': location,
    'seller': seller,
  };

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    imageUrl: json['imageUrl'],
    price: json['price'],
    location: json['location'],
    seller: json['seller'],
  );
}
