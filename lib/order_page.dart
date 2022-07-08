import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/Utils.dart';
import 'package:neg/home_page.dart';
import 'package:neg/main.dart';
import 'package:neg/modal/car.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  final String id;
  const OrderPage({required this.id});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final formKey = GlobalKey<FormState>();

  int currentStep = 0;
  bool withDriver = false;
  bool withFuel = false;
  bool payState = false;
  bool loading = false;
  int surplus = 0;
  int price = 0;
  int fuelFullPrice = 0;
  DateTime currentDate = DateTime.now();
  DateTimeRange _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 1)),
  );

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
      body: payState
          ? buildSuccess()
          : FutureBuilder<Car?>(
              future: readCar(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  final car = snapshot.data;
                  return car == null
                      ? Center(child: Text("No Car"))
                      : builScreen(car);
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

  Widget builScreen(car) {
    bool hideStepBtn = false;
    final start = _dateTimeRange.start;
    final end = _dateTimeRange.end;
    price = car.price;
    fuelFullPrice = car.fuelFullPrice;

    return Stepper(
      controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
        return Row(
          children: <Widget>[
            currentStep == 1
                ? SizedBox()
                : ElevatedButton(
                    onPressed: dtl.onStepContinue,
                    child: Text('Suivant',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: dBlue,
                      padding: const EdgeInsets.all(13),
                    ),
                  ),
            currentStep == 0
                ? SizedBox()
                : ElevatedButton(
                    onPressed: dtl.onStepCancel,
                    child: Text('Précedent',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          color: dGray,
                          fontSize: 15,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding: const EdgeInsets.all(13),
                    ),
                  ),
            SizedBox(width: 15),
            Expanded(
                child: Text(
              "Total à payer : ${(price * _dateTimeRange.duration.inDays) + surplus} XFA",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ))
          ],
        );
      },
      currentStep: currentStep,
      type: StepperType.horizontal,
      onStepTapped: (index) {
        setState(() {
          currentStep = index;
        });
      },
      onStepContinue: () {
        setState(() {
          if (currentStep != 1) {
            currentStep++;
          }
        });
      },
      onStepCancel: () {
        setState(() {
          if (currentStep != 0) {
            currentStep--;
          }
        });
      },
      steps: [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          title: Text(
            "Detail Commande",
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          isActive: currentStep >= 0,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 250,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Image.network(
                    car.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                car.name,
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
                    " ${car.price}XFA/Jour",
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
                      surplus =
                          surplus + (10000 * _dateTimeRange.duration.inDays);
                    } else {
                      surplus =
                          surplus - (10000 * _dateTimeRange.duration.inDays);
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
                      surplus = (surplus + fuelFullPrice);
                    } else {
                      surplus = (surplus - fuelFullPrice);
                    }
                    withFuel = value!;
                  },
                ),
              ),
            ],
          ),
        ),
        Step(
          title: Text(
            "Paiment",
            style: GoogleFonts.nunito(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          isActive: currentStep >= 1,
          content: buildPayForm(car),
        )
      ],
    );
  }

  Widget buildPayForm(car) {
    final paymentIdTransactionController = TextEditingController();
    final paymentPhoneNumberController = TextEditingController();
    final paymentSenderNameController = TextEditingController();

    Future order() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;

      try {
        setState(() {
          loading = true;
        });
        final user = FirebaseAuth.instance.currentUser!;
        FirebaseFirestore.instance.collection('reservations').add({
          'amount': ((price * _dateTimeRange.duration.inDays) + surplus),
          'car': car.toJson(),
          'userId': user.uid,
          'carId': widget.id,
          'date': DateTime.now(),
          'duration': _dateTimeRange.duration.inDays,
          'state': 1,
          'end_date': _dateTimeRange.end,
          'start_date': _dateTimeRange.start,
          'withDriver': withDriver,
          'withFullFuel': withFuel,
          'paymentIdTransaction': paymentIdTransactionController.text.trim(),
          'paymentPhoneNumber': paymentPhoneNumberController.text.trim(),
          'paymentSenderName': paymentSenderNameController.text.trim(),
        });
        setState(() {
          payState = true;
        });
      } catch (e) {
        setState(() {
          loading = false;
        });
        Utils.showSnackBar("Erreur");
      }
    }

    return Form(
      key: formKey,
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
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Total à payer : ${(price * _dateTimeRange.duration.inDays) + surplus} XFA",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
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
            child: TextFormField(
              controller: paymentSenderNameController,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length > 5
                  ? null
                  : 'Entrez au min. 6 caractères',
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
            child: TextFormField(
              controller: paymentPhoneNumberController,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length > 5
                  ? null
                  : 'Entrez au min. 6 caractères',
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
            child: TextFormField(
              controller: paymentIdTransactionController,
              textInputAction: TextInputAction.done,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length > 5
                  ? null
                  : 'Entrez au min. 6 caractères',
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
              onPressed: order,
              child: loading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      "Valider",
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildSuccess() => Center(
          child: Container(
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
      ));
}
