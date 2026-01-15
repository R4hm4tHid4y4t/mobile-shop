import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shoprahmat/config/api_config.dart';
import 'package:shoprahmat/gridelectronic.dart';
import 'package:shoprahmat/gridbajupria.dart';
import 'package:shoprahmat/gridsepatupria.dart';
import 'package:shoprahmat/gridbajuwanita.dart';
import 'package:shoprahmat/gridsepatuwanita.dart';
import 'package:shoprahmat/cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchProduct = TextEditingController();
  PageController bannerController = PageController();
  List<dynamic> listProduct = [];
  Timer? bannerTamer;
  bool isLoading = true;

  int indexBanner = 0;
  
  @override
  void initState() {
    super.initState();
    getProductItem();
    bannerOnBoarding();
  }

  @override
  void dispose() {
    bannerTamer?.cancel();
    bannerController.dispose();
    searchProduct.dispose();
    super.dispose();
  }

  void bannerOnBoarding() {
    bannerTamer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (bannerController.hasClients) {
        if (indexBanner < 2) {
          indexBanner++;
        } else {
          indexBanner = 0;
        }
        bannerController.animateToPage(
          indexBanner,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> getProductItem() async {
    String baseUrl = ApiConfig.baseUrl;
    String urlProductItem = "$baseUrl/servershop_rahmat/allproductitem.php";
    
    if (kDebugMode) {
      print("Requesting URL: $urlProductItem");
    }

    try {
      var response = await http.get(Uri.parse(urlProductItem));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          listProduct = data;
          isLoading = false;
        });
        if (kDebugMode) print("Data fetched: ${listProduct.length} items");
      } else {
         if (kDebugMode) print("Server Error: ${response.statusCode}");
         setState(() => isLoading = false);
      }
    } catch (exc) {
      if (kDebugMode) {
        print("Error fetching data: $exc");
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> bannerImage = [
      'lib/images/e-commerce1.png',
      'lib/images/e-commerce2.png',
      'lib/images/e-commerce3.png',
    ];
    
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
          onPressed: (){}, 
          icon: const Icon(Icons.menu, color: Colors.white)
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white)
          ),
          IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.camera_alt_rounded, color: Colors.white)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: searchProduct,
              decoration: const InputDecoration(
                hintText: 'Search Product',
                hintStyle: TextStyle(color: Colors.black),
                suffixIcon: Icon(Icons.filter_list, size: 17, color: Colors.black),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color.fromARGB(255, 224, 239, 225),
              ),
            ),
            const SizedBox(height: 5),
            
            // Banner Section
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: bannerController,
                itemCount: bannerImage.length,
                itemBuilder: (context, index) {
                  return Image.asset(bannerImage[index], fit: BoxFit.cover);
                }
              ),
            ),

            // Menu Kategori
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCategoryItem(context, 'Electronik', 'lib/images/electronics.png', const GridElectronic()),
                    _buildCategoryItem(context, 'baju pria', 'lib/images/man-shirt.png', const GridBajuPria()),
                    _buildCategoryItem(context, 'sepatu pria', 'lib/images/man-shoes.png', const GridSepatuPria()),
                    _buildCategoryItem(context, 'dress', 'lib/images/woman-shirt.png', const GridBajuWanita()),
                    _buildCategoryItem(context, 'hills', 'lib/images/woman-shoes.png', const GridSepatuWanita()),
                  ],
                ),
              ),
            ),

            // Popular Product Section
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Popular Product",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  
                  if (isLoading) 
                    const Center(child: CircularProgressIndicator())
                  else if (listProduct.isEmpty) ...[
                    const Center(
                      child: Text(
                        "No products available\n(Check Connection or IP)",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ] else ...[
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: listProduct.length,
                      itemBuilder: (context, index) {
                        final productTotal = listProduct[index];
                        return Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  productTotal['images'] ?? '',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, size: 50, color: Colors.grey)
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  productTotal['name'] ?? 'No Name',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Rp.${productTotal['price']}',
                                      style: const TextStyle(color: Colors.red, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ),
                        );
                      },
                    )
                  ]
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, String imgPath, Widget page) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
        child: SizedBox(
          height: 80, width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imgPath, width: 45, height: 45),
              Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }
}
