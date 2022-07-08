import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:neg/main.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SliderSetion(),
            SizedBox(height: 10),
            CategorySection(),
            SizedBox(height: 20),
            // BestCar()
          ],
        ),
      ),
    );
  }
}

class SliderSetion extends StatefulWidget {
  const SliderSetion({Key? key}) : super(key: key);

  @override
  State<SliderSetion> createState() => _SliderSetionState();
}

class _SliderSetionState extends State<SliderSetion> {
  int activeIndex = 0;

  final List cars = [
    {
      "name": "Toyota Tacoma",
      "url": "assets/images/splash/splash1.jpg",
      "tag": "Nouveau",
      "start_price": 70000
    },
    {
      "name": "Mercedes Benz",
      "url": "assets/images/splash/splash2.jpg",
      "tag": "Nouveau",
      "start_price": 550000
    },
    {
      "name": "BMW Xtread",
      "url": "assets/images/splash/splash3.jpg",
      "tag": "Nouveau",
      "start_price": 170000
    },
    {
      "name": "Toyota Fortuner",
      "url": "assets/images/splash/splash4.jpg",
      "tag": "Nouveau",
      "start_price": 620000
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: cars.length,
          itemBuilder: (context, index, realIndex) {
            final car = cars[index];
            return buildImage(car, index);
          },
          options: CarouselOptions(
              height: 200,
              viewportFraction: 1,
              autoPlay: true,
              // enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              autoPlayInterval: Duration(seconds: 5),
              onPageChanged: (index, reason) =>
                  setState(() => activeIndex = index)),
        ),
        const SizedBox(
          height: 10,
        ),
        buildIndicator(),
      ],
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: cars.length,
        effect: const ExpandingDotsEffect(
            dotHeight: 5,
            dotWidth: 5,
            dotColor: Colors.black12,
            activeDotColor: dBlue),
      );

  Widget buildImage(car, int index) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(car['url']),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 5,
              left: 7,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: dBlue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: Text(
                  "Nouveau",
                  style: GoogleFonts.nunito(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car['name'],
                    style: GoogleFonts.nunito(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "A partir de ${car['start_price']}/jour",
                    style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          ],
        ),
      );
}

class CategorySection extends StatefulWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final Stream<QuerySnapshot> _categoriesStream =
      FirebaseFirestore.instance.collection('categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Type de véhicule",
                style: GoogleFonts.nunito(
                    fontSize: 20, fontWeight: FontWeight.w700, color: dGray),
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  "Voir tout",
                  style: GoogleFonts.nunito(
                      fontSize: 16, fontWeight: FontWeight.w500, color: dGray),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: StreamBuilder<QuerySnapshot>(
              stream: _categoriesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Something went wrong',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, fontSize: 18)));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: dBlue),
                  );
                }

                return Row(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        height: 100,
                        width: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18),
                          ),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.network(
                              data['image'],
                              width: 70,
                              height: 70,
                            ),
                            Text(
                              data['name'],
                              style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: dGray),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class BestCar extends StatefulWidget {
  const BestCar({Key? key}) : super(key: key);

  @override
  State<BestCar> createState() => _BestCarState();
}

class _BestCarState extends State<BestCar> {
  final List cars = [
    {
      "name": "Toyota Tacoma",
      "price": 750004,
      "category": "SUV",
      "url": "assets/images/voitures/voiture1.jpg",
    },
    {
      "name": "Mercedes Benz",
      "price": 750004,
      "category": "Berline",
      "url": "assets/images/voitures/voiture2.jpg",
    },
    {
      "name": "BMW Xtread",
      "price": 750004,
      "category": "Berline",
      "url": "assets/images/voitures/voiture3.png",
    },
    {
      "name": "Toyota Fortuner",
      "price": 750004,
      "category": "SUV",
      "url": "assets/images/voitures/voiture4.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 80),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nos meilleurs véhicules",
                style: GoogleFonts.nunito(
                    fontSize: 20, fontWeight: FontWeight.w700, color: dGray),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: cars.map((car) {
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: 120,
                child: Row(
                  children: [
                    Container(
                      height: double.infinity,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage(car['url']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${car['name']}",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${car['category']}",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            "${car['price']} XFA/Jour",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
