class LaptopModel {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String description;
  final String specs;
  final String gambar;
  final String kategori;

  LaptopModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
    required this.specs,
    this.gambar = '',
    this.kategori = 'Gaming',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'description': description,
      'specs': specs,
      'gambar': gambar,
      'kategori': kategori,
    };
  }

  factory LaptopModel.fromMap(Map<String, dynamic> map) {
    return LaptopModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String? ?? '',
      specs: map['specs'] as String? ?? '',
      gambar: map['gambar'] as String? ?? '',
      kategori: map['kategori'] as String? ?? 'Gaming',
    );
  }

  factory LaptopModel.fromJson(Map<String, dynamic> json) => LaptopModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

