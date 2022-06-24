import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          "Commande",
          style: GoogleFonts.nunito(color: dGray),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SlidingUpPanel(
        maxHeight: size.height * 0.8,
        minHeight: size.height * 0.05,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        backdropEnabled: true,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 200,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: dBlue,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(13),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Commander",
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        panel: Container(),
      ),
    );
  }
}
