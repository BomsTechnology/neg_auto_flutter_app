import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/main.dart';
import 'package:neg/detail_page.dart';

class CarPage extends StatefulWidget {
  const CarPage({Key? key}) : super(key: key);

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: dBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white, shape: const StadiumBorder()),
                    child: Row(
                      children: [
                        Text(
                          'Filters',
                          style: GoogleFonts.nunito(
                            color: dGray,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.filter_list_outlined,
                          color: dGray,
                        )
                      ],
                    ))
              ],
            ),
          ),
          CarSection(),
        ],
      ),
    );
  }
}

class CarSection extends StatefulWidget {
  const CarSection({Key? key}) : super(key: key);

  @override
  State<CarSection> createState() => _CarSectionState();
}

class _CarSectionState extends State<CarSection> {
  final List cars = [
    {
      "name": "Toyota Tacoma",
      "url": "assets/images/splash/splash1.jpg",
    },
    {
      "name": "Mercedes Benz",
      "url": "assets/images/splash/splash2.jpg",
    },
    {
      "name": "BMW Xtread",
      "url": "assets/images/voitures/voiture3.png",
    },
    {
      "name": "Toyota Fortuner",
      "url": "assets/images/voitures/voiture4.jpg",
    },
    {
      "name": "Toyota Tacoma",
      "url": "assets/images/voitures/voiture1.jpg",
    },
    {
      "name": "Mercedes Benz",
      "url": "assets/images/voitures/voiture2.jpg",
    },
    {
      "name": "BMW Xtread",
      "url": "assets/images/voitures/voiture3.png",
    },
    {
      "name": "Toyota Fortuner",
      "url": "assets/images/voitures/voiture4.jpg",
    },
    {
      "name": "Toyota Tacoma",
      "url": "assets/images/voitures/voiture1.jpg",
    },
    {
      "name": "Mercedes Benz",
      "url": "assets/images/voitures/voiture2.jpg",
    },
    {
      "name": "BMW Xtread",
      "url": "assets/images/voitures/voiture3.png",
    },
    {
      "name": "Toyota Fortuner",
      "url": "assets/images/voitures/voiture4.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildGrid(),
    );
  }

  Widget buildGrid() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
        ),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
        itemCount: cars.length,
        itemBuilder: (context, index) {
          final item = cars[index];
          return buildCard(item);
        },
      );
  Widget buildCard(car) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black12),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(),
              ),
            );
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Image.asset(
                    car['url'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                car['name'],
                textAlign: TextAlign.center,
                softWrap: true,
                style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
}
