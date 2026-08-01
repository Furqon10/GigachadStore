class CartItemModel {
  final int? id;
  final String productId;
  final String namaProduk;
  final double harga;
  int qty;
  final String gambar;

  CartItemModel({
    this.id,
    required this.productId,
    required this.namaProduk,
    required this.harga,
    required this.qty,
    this.gambar = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'product_id': productId,
      'nama_produk': namaProduk,
      'harga': harga,
      'qty': qty,
      'gambar': gambar,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as int?,
      productId: map['product_id'] as String? ?? '',
      namaProduk: map['nama_produk'] as String? ?? '',
      harga: (map['harga'] as num).toDouble(),
      qty: map['qty'] as int? ?? 1,
      gambar: map['gambar'] as String? ?? '',
    );
  }
}

