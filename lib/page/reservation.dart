import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/main.dart';
import 'package:sliding_switch/sliding_switch.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  int currentScreen = 0;
  final List screens = [InProgressCar(), HistoryCar()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            color: dBlue,
            child: Text(
              "Vos Reservations",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: SlidingSwitch(
              value: false,
              width: 250,
              onChanged: (bool value) {
                setState(() {
                  currentScreen = currentScreen == 0 ? 1 : 0;
                });
              },
              height: 40,
              animationDuration: const Duration(milliseconds: 400),
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              textOff: "En Cours",
              textOn: "Historique",
              colorOn: const Color(0xffdc6c73),
              colorOff: dBlue,
              background: const Color(0xffe4e5eb),
              buttonColor: const Color(0xfff7f5f7),
              inactiveColor: dGray,
            ),
          ),
          const SizedBox(height: 10),
          screens[currentScreen]
        ],
      ),
    );
  }
}

class InProgressCar extends StatefulWidget {
  const InProgressCar({Key? key}) : super(key: key);

  @override
  State<InProgressCar> createState() => _InProgressCarState();
}

class _InProgressCarState extends State<InProgressCar> {
  final List cars = [
    {
      "name": "Mercedes Benz",
      "start_date": "23/05/22",
      "end_date": "27/05/22",
      "price": 7894512,
      "status": "En Service",
      "url": "assets/images/voitures/voiture2.jpg",
    },
    {
      "name": "BMW Xtread",
      "start_date": "23/05/22",
      "end_date": "27/05/22",
      "price": 7894512,
      "status": "En Attente",
      "url": "assets/images/voitures/voiture3.png",
    },
    {
      "name": "Toyota Fortuner",
      "start_date": "23/05/22",
      "end_date": "27/05/22",
      "price": 7894512,
      "status": "En Service",
      "url": "assets/images/voitures/voiture4.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildList(),
    );
  }

  Widget buildList() => ListView.builder(
        itemCount: cars.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final car = cars[index];
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
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        image: AssetImage(car['url']),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 5,
                          left: 5,
                          child: car['status'] == "En Service"
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: dBlue,
                                  ),
                                  child: Text(
                                    car['status'],
                                    style:
                                        GoogleFonts.nunito(color: Colors.white),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      color: Colors.orange),
                                  child: Text(
                                    car['status'],
                                    style:
                                        GoogleFonts.nunito(color: Colors.white),
                                  ),
                                ),
                        )
                      ],
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
                          "${car['start_date']} - ${car['end_date']}",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "${car['price']} XFA",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        },
      );
}

class HistoryCar extends StatefulWidget {
  const HistoryCar({Key? key}) : super(key: key);

  @override
  State<HistoryCar> createState() => _HistoryCarState();
}

class _HistoryCarState extends State<HistoryCar> {
  final List cars = [
    {
      "name": "Mercedes Benz",
      "start_date": "23/05/22",
      "end_date": "27/05/22",
      "price": 7894512,
      "status": "Expiré",
      "url": "assets/images/voitures/voiture2.jpg",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: buildList(),
    );
  }

  Widget buildList() => ListView.builder(
        itemCount: cars.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final car = cars[index];
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
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage(car['url']),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        left: 5,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.red),
                          child: Text(
                            car['status'],
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                        ),
                      )
                    ],
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
                        "${car['start_date']} - ${car['end_date']}",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "${car['price']} XFA",
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
        },
      );
}
