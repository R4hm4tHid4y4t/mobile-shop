import 'package:flutter/material.dart';
import 'package:shoprahmat/homepage.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController boardingController = PageController();
  int indexPage = 0;

  List<Map<String, String>> dataRahmat = [
    {
      "title": "Welcome to Rahmat Shop",
      "subTittle": "Discover various quality product in our store",
      "image": "https://th.bing.com/th/id/R.5258134de0d98bed6e7095835edaeef8?rik=oLHImd1ONjWg5g&riu=http%3a%2f%2fclipart-library.com%2fimage_gallery%2fn1105478.png&ehk=FePBi%2fSAX9bFABi21I21NVbMMUgwBnU%2fXc3EO5XP0%2bY%3d&risl=&pid=ImgRaw&r=0"
    },
    {
      "title": "Electronics",
      "subTittle": "Find the latest gadgets and electronic devices",
      "image": "https://tse1.mm.bing.net/th/id/OIP.joQKXsUlCNaJxK7eXPkEoQHaHa?rs=1&pid=ImgDetMain&o=7&rm=3"
    },
    {
      "title": "Men's Clothing",
      "subTittle": "Stylish shirts and apparel for men",
      "image": "https://th.bing.com/th/id/OIP.ItFdMd3TYXjbe1pdDSzTQAHaHa?w=203&h=203&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3"
    },
    {
      "title": "Men's Shoes",
      "subTittle": "Comfortable and trendy footwear for men",
      "image": "https://tse1.mm.bing.net/th/id/OIP.rzK2ol6mZaVwsNwuZNwKqAAAAA?rs=1&pid=ImgDetMain&o=7&rm=3"
    },
    {
      "title": "Women's Dress",
      "subTittle": "Elegant dresses for every occasion",
      "image": "https://static.vecteezy.com/system/resources/previews/046/482/003/non_2x/modern-and-stylish-woman-bathrobe-dress-mockup-black-color-illustration-vector.jpg"
    },
    {
      "title": "Women's Heels",
      "subTittle": "Beautiful heels to complete your look",
      "image": "https://media.istockphoto.com/id/1176968720/id/vektor/ikon-sepatu-hak-tinggi-siluet-hitam-yang-elegan-tanda-informasi-simbol-sepatu-wanita-label.jpg?s=170667a&w=0&k=20&c=EnNFa7iZkH2UYT1BImpNsMzgWBcQNZKSwSlvWDKGIYQ="
    },
    {
      "title": "Get started",
      "subTittle": "Begin your shopping experience",
      "image": "https://avatars.githubusercontent.com/u/182461235?s=400&u=c02a05d01c26c6513a9287d029efb33df7fba708&v=4"
    },
  ];

  @override
  void initState() {
    super.initState();
    boardingController = PageController();
    boardingController.addListener(() {
      setState(() {
        indexPage = boardingController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    boardingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: boardingController,
              itemCount: dataRahmat.length,
              itemBuilder: (context, index) {
                return OnboardingLayout(
                  title: "${dataRahmat[index]['title']}",
                  subTittle: "${dataRahmat[index]['subTittle']}",
                  image: "${dataRahmat[index]['image']}",
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: List.generate(
                    dataRahmat.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: indexPage == index ? Colors.black54 : Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (indexPage == dataRahmat.length - 1) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      } else {
                        boardingController.nextPage(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_forward, size: 20),
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

class OnboardingLayout extends StatelessWidget {
  const OnboardingLayout({
    super.key,
    required this.title,
    required this.subTittle,
    required this.image
  });

  final String title;
  final String subTittle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(
          image,
          height: 350,
          width: 300,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subTittle,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}