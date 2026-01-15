class CartItem {
  final int id;
  final int productId;
  final String name;
  final double price;
  final double promo;
  final String images;
  final int quantity;
  final int stock;
  final String vendors;
  final double subtotal;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.promo,
    required this.images,
    required this.quantity,
    required this.stock,
    required this.vendors,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      promo: double.parse(json['promo'].toString()),
      images: json['images'],
      quantity: json['quantity'],
      stock: json['stock'],
      vendors: json['vendors'],
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }

  double get finalPrice => promo > 0 ? promo : price;
}

class CartResponse {
  final String status;
  final List<CartItem> data;
  final int totalItems;
  final double totalPrice;

  CartResponse({
    required this.status,
    required this.data,
    required this.totalItems,
    required this.totalPrice,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalItems: json['total_items'],
      totalPrice: double.parse(json['total_price'].toString()),
    );
  }
}
