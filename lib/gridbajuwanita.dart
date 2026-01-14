import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shoprahmat/config/api_config.dart';

class GridBajuWanita extends StatefulWidget {
  const GridBajuWanita({super.key});
  @override
  State<GridBajuWanita> createState() => _GridBajuWanitaState();
}

class _GridBajuWanitaState extends State<GridBajuWanita> {
  List<dynamic> bajuWanitaProduct = [];
  bool isLoading = true;
  String errorMessage = "";
  
  Future<void> getBajuWanita() async {
    String baseUrl = ApiConfig.baseUrl;
    String urlBajuWanita = "$baseUrl/servershop_rahmat/gridbajuwanita.php";
    
    setState(() { isLoading = true; errorMessage = ""; });

    try {
      var response = await http.get(Uri.parse(urlBajuWanita)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        setState(() {
          bajuWanitaProduct = json.decode(response.body);
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
  void initState() { super.initState(); getBajuWanita(); }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Women's Dress", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: Colors.green, centerTitle: true, leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white))),
      body: isLoading ? const Center(child: CircularProgressIndicator()) 
        : errorMessage.isNotEmpty ? Center(child: Text(errorMessage))
        : bajuWanitaProduct.isEmpty ? const Center(child: Text("Produk Kosong"))
        : Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7),
              itemCount: bajuWanitaProduct.length,
              itemBuilder: (context, index) {
                final item = bajuWanitaProduct[index];
                String imageUrl = (item['image'] ?? item['images'] ?? '').toString().trim();
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBajuWanita(item: item))),
                  child: Card(
                    elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [
                      Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(12)), child: Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image)))),
                      Padding(padding: const EdgeInsets.all(8), child: Text(item['name']??'-', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      
                      // HARGA & PROMO DIKEMBALIKAN
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text("Rp.${item['price']}", overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color.fromARGB(137, 71, 152, 202), fontWeight: FontWeight.bold, fontSize: 10))),
                            Row(children: [const Icon(Icons.favorite, color: Colors.red, size: 12), const SizedBox(width: 3), Text("Rp.${item['promo']}", style: const TextStyle(color: Color.fromARGB(136, 56, 176, 88), fontWeight: FontWeight.bold, fontSize: 10))]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                    ]),
                  ),
                );
              }
            )
          ),
    );
  }
}

class DetailBajuWanita extends StatelessWidget {
  const DetailBajuWanita({super.key, required this.item});
  final dynamic item;
  @override
  Widget build(BuildContext context) {
    String imageUrl = (item['image'] ?? item['images'] ?? '').toString().trim();
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk"), backgroundColor: Colors.green),
      body: SingleChildScrollView(child: Column(children: [
        Image.network(imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover, errorBuilder: (ctx,err,stack)=>const Icon(Icons.broken_image, size: 50)),
        Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item['name']??'-', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Rp.${item['price']}", style: const TextStyle(fontSize: 18, color: Color.fromARGB(137, 71, 152, 202), fontWeight: FontWeight.bold)),
              Row(children: [const Icon(Icons.favorite, color: Colors.red), const SizedBox(width: 5), Text("Rp.${item['promo']}", style: const TextStyle(fontSize: 18, color: Color.fromARGB(136, 56, 176, 88), fontWeight: FontWeight.bold))]),
            ],
          ),
          const SizedBox(height: 20), const Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)), Text(item['description']??'-'),
        ]))
      ])),
    );
  }
}