import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shoprahmat/config/api_config.dart';

class GridBajuPria extends StatefulWidget {
  const GridBajuPria({super.key});
  
  @override
  State<GridBajuPria> createState() => _GridBajuPriaState();
}

class _GridBajuPriaState extends State<GridBajuPria> {
  List<dynamic> bajuPriaProduct = [];
  
  Future<void> getBajuPria() async {
    String baseUrl = ApiConfig.baseUrl;
    String urlBajuPria = "$baseUrl/servershop_rahmat/gridbajupria.php";
    try {
      var response = await http.get(Uri.parse(urlBajuPria));
      setState(() {
        bajuPriaProduct = json.decode(response.body);
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }
  
  @override
  void initState() {
    super.initState();
    getBajuPria();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Men's Clothing",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: bajuPriaProduct.length,
          itemBuilder: (context, index) {
            final item = bajuPriaProduct[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBajuPria(item: item)
                  )
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        item['images'],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        item['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Rp.${item['price']}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color.fromARGB(137, 71, 152, 202),
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                              )
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 12,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                "Rp.${item['promo']}",
                                style: const TextStyle(
                                  color: Color.fromARGB(136, 56, 176, 88),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
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

class DetailBajuPria extends StatelessWidget {
  const DetailBajuPria({super.key, required this.item});
  final dynamic item;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rahmat Online Shop",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 22,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['images'],
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Product Description',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                item['description'],
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  height: 1.5
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rp.${item['price']}",
                    style: const TextStyle(
                      color: Color.fromARGB(137, 71, 152, 202),
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    )
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Rp.${item['promo']}",
                        style: const TextStyle(
                          color: Color.fromARGB(136, 56, 176, 88),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}