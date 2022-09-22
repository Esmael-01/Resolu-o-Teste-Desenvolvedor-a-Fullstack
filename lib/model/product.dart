import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product {
  Product({
    required this.hasDiscount,
    required this.name,
    required this.gallery,
    required this.description,
    required this.price,
    required this.discountValue,
    required this.details,
    required this.id,
  });

  bool hasDiscount;
  String name;
  List<String> gallery;
  String description;
  String price;
  String discountValue;
  Details details;
  String id;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        hasDiscount: json["hasDiscount"],
        name: json["name"],
        gallery: List<String>.from(json["gallery"].map((x) => x)),
        description: json["description"],
        price: json["price"],
        discountValue: json["discountValue"],
        details: Details.fromJson(json["details"]),
        id: json["id"],
      );
}

class Details {
  Details({
    required this.adjective,
    required this.material,
  });

  String adjective;
  String material;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        adjective: json["adjective"],
        material: json["material"],
      );
}
