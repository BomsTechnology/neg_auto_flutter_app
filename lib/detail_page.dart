import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neg/main.dart';
import 'package:neg/order_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

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

  final detail = [
    {"name": "Couleur", "value": "Grise"},
    {"name": "Boite de vitesse", "value": "Automatique"},
    {"name": "Puissance", "value": 100},
    {"name": "Nombre de place", "value": 5},
    {"name": "Nombre de portiere", "value": 5},
  ];
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 250,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Image.asset(
                "assets/images/voitures/voiture4.jpg",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "Toyota Tacoma",
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
                "SUV ",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 10,
                child: Text("-"),
              ),
              Text(
                "750000 XFA/Jour",
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
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
              tabs: [
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
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
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
                          children: detail.map((d) {
                        return buildCaracteristique(d);
                      }).toList()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCaracteristique(caracteristique) => SizedBox(
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
                  "${caracteristique['name']} :",
                  style: GoogleFonts.nunito(
                      fontSize: 18,
                      letterSpacing: 1,
                      height: 1.5,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Text(
              " ${caracteristique['value']}",
              style: GoogleFonts.nunito(
                fontSize: 18,
                letterSpacing: 1,
                height: 1.5,
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
