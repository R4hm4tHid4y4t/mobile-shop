class CartResponse {
  final String status;
  final List<CartItem> items;
  final double total;

  CartResponse({
    required this.status,
    required this.items,
    required this.total,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      status: json['status'] ?? 'error',
      items: (json['items'] as List?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class CartItem {
  final int cartId;
  final int productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final double subtotal;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: int.tryParse(json['cart_id']?.toString() ?? '0') ?? 0,
      productId: int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}
