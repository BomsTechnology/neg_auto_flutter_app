class Car {
  Car({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.state,
    required this.caution,
    required this.category,
    required this.brand,
    required this.fuelFullPrice,
    required this.features,
  });

  Car.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          image: json['image']! as String,
          price: json['price']! as int,
          description: json['description']! as String,
          state: json['state']! as int,
          caution: json['caution']! as int,
          brand: json['brand']!,
          category: json['category']!,
          fuelFullPrice: json['fuelFullPrice']! as int,
          features: json['features']!,
        );

  final String name;
  final String image;
  final int price;
  final String description;
  final int state;
  final int caution;
  final Object category;
  final Object brand;
  final int fuelFullPrice;
  final Object features;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'image': image,
      "price": price,
      "description": description,
      "state": state,
      "caution": caution,
      "category": category,
      "brand": brand,
      "fuelFullPrice": fuelFullPrice,
      "features": features,
    };
  }
}
