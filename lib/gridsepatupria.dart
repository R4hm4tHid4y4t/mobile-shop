import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shoprahmat/config/api_config.dart';

class GridSepatuPria extends StatefulWidget {
  const GridSepatuPria({super.key});
  
  @override
  State<GridSepatuPria> createState() => _GridSepatuPriaState();
}

class _GridSepatuPriaState extends State<GridSepatuPria> {
  List<dynamic> sepatuPriaProduct = [];
  bool isLoading = true;
  String errorMessage = "";
  
  Future<void> getSepatuPria() async {
    String baseUrl = ApiConfig.baseUrl;
    String urlSepatuPria = "$baseUrl/servershop_rahmat/gridsepatupria.php";
    
    setState(() { isLoading = true; errorMessage = ""; });

    try {
      var response = await http.get(Uri.parse(urlSepatuPria)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        setState(() {
          sepatuPriaProduct = json.decode(response.body);
          isLoading = false;
        });
      } else {
         setState(() { isLoading = false; errorMessage = "Server Error: ${response.statusCode}"; });
      }
    } catch (exc) {
      setState(() { isLoading = false; errorMessage = "Koneksi Gagal: $exc"; });
    }
  }
  
  @override
  void initState() { super.initState(); getSepatuPria(); }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Men's Shoes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, textAlign: TextAlign.center))
          : sepatuPriaProduct.isEmpty
            ? const Center(child: Text("Produk Kosong"))
            : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7,
                  ),
                  itemCount: sepatuPriaProduct.length,
                  itemBuilder: (context, index) {
                    final item = sepatuPriaProduct[index];
                    // FIX: Baca 'image' atau 'images'
                    String imageUrl = (item['image'] ?? item['images'] ?? '').toString().trim();

                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailSepatuPria(item: item))),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(item['name'] ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            // BAGIAN HARGA & PROMO DIKEMBALIKAN SEPERTI SEMULA
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Rp.${item['price']}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Color.fromARGB(137, 71, 152, 202), fontWeight: FontWeight.bold, fontSize: 10),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.favorite, color: Colors.red, size: 12),
                                      const SizedBox(width: 3),
                                      Text(
                                        "Rp.${item['promo']}",
                                        style: const TextStyle(color: Color.fromARGB(136, 56, 176, 88), fontWeight: FontWeight.bold, fontSize: 10),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ]
                        ),
                      ),
                    );
                  }
                )
              ),
    );
  }
}

class DetailSepatuPria extends StatelessWidget {
  const DetailSepatuPria({super.key, required this.item});
  final dynamic item;
  
  @override
  Widget build(BuildContext context) {
    String imageUrl = (item['image'] ?? item['images'] ?? '').toString().trim();
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => const SizedBox(height: 300, child: Center(child: Icon(Icons.broken_image, size: 50))),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] ?? '-', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // HARGA DETAIL JUGA DIKEMBALIKAN LENGKAP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rp.${item['price']}", style: const TextStyle(fontSize: 18, color: Color.fromARGB(137, 71, 152, 202), fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red),
                          const SizedBox(width: 5),
                          Text("Rp.${item['promo']}", style: const TextStyle(fontSize: 18, color: Color.fromARGB(136, 56, 176, 88), fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(item['description'] ?? '-'),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}