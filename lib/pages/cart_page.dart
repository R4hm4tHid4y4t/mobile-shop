import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/cart_model.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];
  double _totalPrice = 0;
  bool _isLoading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('user_id');

    if (_userId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final cartResponse = await ApiService.getCart(_userId!);
    
    if (cartResponse != null) {
      setState(() {
        _cartItems = cartResponse.data;
        _totalPrice = cartResponse.totalPrice;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(int cartId, int newQuantity) async {
    if (newQuantity < 1) return;

    final result = await ApiService.updateCartQuantity(
      cartId: cartId,
      quantity: newQuantity,
    );

    if (result['status'] == 'success') {
      _loadCart(); // Reload cart
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteItem(int cartId) async {
    final result = await ApiService.deleteCartItem(cartId);

    if (result['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );
      _loadCart(); // Reload cart
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Keranjang Kosong',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item.images,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[200],
                                          child: Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  
                                  // Product Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item.vendors,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          _formatCurrency(item.finalPrice),
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        
                                        // Quantity Controls
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove_circle_outline),
                                              onPressed: () {
                                                _updateQuantity(
                                                  item.id,
                                                  item.quantity - 1,
                                                );
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              '${item.quantity}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            IconButton(
                                              icon: Icon(Icons.add_circle_outline),
                                              onPressed: () {
                                                if (item.quantity < item.stock) {
                                                  _updateQuantity(
                                                    item.id,
                                                    item.quantity + 1,
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('Stok tidak mencukupi'),
                                                      backgroundColor: Colors.orange,
                                                    ),
                                                  );
                                                }
                                              },
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                            ),
                                            Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text('Hapus Item'),
                                                    content: Text(
                                                      'Yakin ingin menghapus item ini?',
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text('Batal'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                          _deleteItem(item.id);
                                                        },
                                                        child: Text(
                                                          'Hapus',
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Bottom Total & Checkout
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total (${_cartItems.length} item)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _formatCurrency(_totalPrice),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Implementasi checkout
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Fitur checkout akan segera hadir'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
