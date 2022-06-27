import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/home_page.dart';
import 'package:neg/main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  PanelController _panelController = PanelController();
  bool withDriver = false;
  bool withFuel = false;
  bool payState = false;
  int surplus = 0;
  DateTime currentDate = DateTime.now();
  DateTimeRange _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

  void tooglePannel() => _panelController.isPanelOpen
      ? _panelController.close()
      : _panelController.open();

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _dateTimeRange,
      firstDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
      lastDate: DateTime(2100),
    );

    if (newDateRange == null) return;

    setState(() {
      _dateTimeRange = newDateRange;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final start = _dateTimeRange.start;
    final end = _dateTimeRange.end;
    final price = 750000;
    final fullFuel = 20000;
    final period = _dateTimeRange.duration.inDays;
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
        controller: _panelController,
        parallaxEnabled: true,
        maxHeight: size.height * 0.8,
        minHeight: size.height * 0.12,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        backdropEnabled: true,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 320,
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
              const SizedBox(height: 5),
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
                    " ${price}XFA/Jour",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Période de location",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: pickDateRange,
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${DateFormat('dd/MM/yyyy').format(start)} - ${DateFormat('dd/MM/yyyy').format(end)}",
                          style: GoogleFonts.nunito(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_month,
                          color: dGray,
                        ),
                        onPressed: pickDateRange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                activeColor: dBlue,
                value: withDriver,
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/icone/driver.png',
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Avec Chauffeur",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                onChanged: (value) => setState(
                  () {
                    if (value == true) {
                      surplus = surplus + (10000 * period);
                    } else {
                      surplus = surplus - (10000 * period);
                    }
                    withDriver = value!;
                  },
                ),
              ),
              CheckboxListTile(
                activeColor: dBlue,
                value: withFuel,
                title: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icone/fuel.svg',
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Plein d'éssence",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                onChanged: (value) => setState(
                  () {
                    if (value == true) {
                      surplus = surplus + fullFuel;
                    } else {
                      surplus = surplus - fullFuel;
                    }
                    withFuel = value!;
                  },
                ),
              ),
            ],
          ),
        ),
        panelBuilder: (controller) {
          return SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: tooglePannel,
                  child: Center(
                    child: Container(
                      height: 10,
                      width: 30,
                      margin: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: dBlue),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total à payer: ",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      " ${(price * period) + surplus} XFA",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                !payState ? buildPayForm() : buildSuccess()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPayForm() => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              "(Effectuer un dépot correspondant au montant à payer sur l'un des numéros ci-après et renseigner les champs ci-dessous)",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w500,
                color: dGray,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "ORANGE : ",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w500,
                    color: dGray,
                    fontSize: 18,
                  ),
                ),
                Text(
                  " +237 6 58 40 11 81",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    color: dGray,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "MTN : ",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w500,
                    color: dGray,
                    fontSize: 18,
                  ),
                ),
                Text(
                  " +237 6 75 85 63 06",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    color: dGray,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: Offset(0, 3)),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.nunito(color: Colors.grey),
                    hintText: "Nom de l'expéditeur",
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: Offset(0, 3)),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.nunito(color: Colors.grey),
                    hintText: "Numéro de téléphone",
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: Offset(0, 3)),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.nunito(color: Colors.grey),
                    hintText: "ID de la Transaction",
                    contentPadding: EdgeInsets.all(10),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: dBlue,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.all(13),
                ),
                onPressed: () {
                  setState(() {
                    payState = true;
                  });
                },
                child: Text(
                  "Valider",
                  style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildSuccess() => Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            const FaIcon(
              FontAwesomeIcons.circleCheck,
              size: 150,
              color: Colors.green,
            ),
            const SizedBox(height: 50),
            Text(
              "Tous les détails liées à la location #R00207 sont à consulter dans vos reservations, veillez patienter sa validation",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w500,
                color: dGray,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
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
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Text(
                  "Retour à l'acceuil",
                  style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );
}
