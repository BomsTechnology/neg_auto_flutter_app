import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neg/Utils.dart';
import 'package:neg/main.dart';
import 'package:neg/order_page.dart';
import 'package:neg/modal/car.dart';

class DetailPage extends StatefulWidget {
  final String id;
  const DetailPage({required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: dGray,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Détails",
          style: GoogleFonts.nunito(color: dGray),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Car?>(
          future: readCar(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error : ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final car = snapshot.data;
              return car == null
                  ? Center(child: Text("No Car"))
                  : buildCar(car);
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: dBlue,
              ));
            }
          }),
    );
  }

  Future<Car?> readCar() async {
    final docCar = FirebaseFirestore.instance.collection('cars');

    final snapshot = await docCar.doc(widget.id).get();

    if (snapshot.exists) {
      return Car.fromJson(snapshot.data()!);
    } else {
      Utils.showSnackBar('Cette voiture n\'existe pas');
    }
  }

  Widget buildCar(car) => Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            height: 250,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(car.image),
                  fit: BoxFit.cover,
                )),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: car.state == 1 ? Colors.green : Colors.amber,
                    ),
                    child: Text(
                      car.state == 1 ? "Disponible" : "Indisponible",
                      style: GoogleFonts.nunito(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            car.name,
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${car.category['name']} ",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 10,
                child: Text("|"),
              ),
              Text(
                "${car.price}XFA/Jour",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: dBlue,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(13),
              ),
              onPressed: () {
                if (car.state != 1) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(
                      id: widget.id,
                    ),
                  ),
                );
              },
              child: Text(
                "Continuer",
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Container(
            child: TabBar(
              controller: _tabController,
              labelColor: dGray,
              isScrollable: true,
              padding: const EdgeInsets.only(left: 15, right: 15),
              labelStyle: GoogleFonts.nunito(
                fontSize: 18,
              ),
              unselectedLabelColor: Colors.black12,
              indicatorColor: dBlue,
              tabs: const [
                Tab(text: 'Description'),
                Tab(text: 'Caractéristiques'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "${car.description}",
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          letterSpacing: 1,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                      child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icone/hashtag.svg',
                                    color: dBlue,
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Couleur :",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        height: 1.5,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Text(
                                " ${car.features['color']}",
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icone/hashtag.svg',
                                    color: dBlue,
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Air Conditionner :",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        height: 1.5,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Text(
                                car.features['airConditionner'] ? "Oui" : "Non",
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icone/hashtag.svg',
                                    color: dBlue,
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Boite de vitesse :",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        height: 1.5,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Text(
                                " ${car.features['geatBox']}",
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icone/hashtag.svg',
                                    color: dBlue,
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Nombre de place :",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        height: 1.5,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Text(
                                " ${car.features['nbPlaces']}",
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icone/hashtag.svg',
                                    color: dBlue,
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Nombre de porte :",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        height: 1.5,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Text(
                                " ${car.features['nbDoor']}",
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icone/hashtag.svg',
                                    color: dBlue,
                                    width: 18,
                                    height: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Puissance :",
                                    style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        height: 1.5,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              Text(
                                " ${car.features['power']} Chevaux",
                                style: GoogleFonts.nunito(
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
