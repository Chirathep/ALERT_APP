import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({Key? key}) : super(key: key);

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  final auth = FirebaseAuth.instance;
  CarouselController buttonCarouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        leadingWidth: 0,
        elevation: 0,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/alertlogo.png',
                width: 85,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[50],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text('data'),
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: imageSliders,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> imgList = [
  'https://as2.ftcdn.net/v2/jpg/00/68/93/99/1000_F_68939938_1ORDlfCxDBFwEMQPRcc2TVf8TY8HUExL.jpg',
  'https://as1.ftcdn.net/v2/jpg/01/10/29/28/1000_F_110292817_GmAFbu8urNF2rDYSNE8NxZSgecLW3htA.jpg',
  'https://as2.ftcdn.net/v2/jpg/00/61/91/61/1000_F_61916143_GBXXmWvNntZvzzJd5rIbW8QGLQY7yj25.jpg',
  'https://as2.ftcdn.net/v2/jpg/00/75/42/37/1000_F_75423712_BoZELHCJ6RimxwKRxxDi3txoJG7zp2Wr.jpg',
  'https://as2.ftcdn.net/v2/jpg/00/84/36/91/1000_F_84369125_kjr518mHczYWcHcXW4ft8bDjKU96z6ja.jpg',
  'https://as2.ftcdn.net/v2/jpg/01/04/04/09/1000_F_104040956_hzyHsnILfYpBNnZqr3NBXJ3gJinbbwV8.jpg'
];
final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'No. ${imgList.indexOf(item)} image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ))
    .toList();
