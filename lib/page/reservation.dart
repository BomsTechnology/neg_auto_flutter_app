import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:neg/main.dart';
import 'package:neg/modal/car.dart';
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
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _reservationStream = FirebaseFirestore.instance
        .collection('reservations')
        .where('userId', isEqualTo: user.uid)
        .where('state', isNotEqualTo: 3)
        .snapshots();
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _reservationStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                  child: Text('Something went wrong ${snapshot.error}',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700, fontSize: 18)));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: dBlue),
              );
            }

            if (snapshot.data?.size == 0) {
              return Center(
                child: Text('Aucune Reservation en cours',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700, fontSize: 18)),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  final String id = document.id;
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return buildCar(data);
                }).toList(),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
              );
            }
          }),
    );
  }
}

class HistoryCar extends StatefulWidget {
  const HistoryCar({Key? key}) : super(key: key);

  @override
  State<HistoryCar> createState() => _HistoryCarState();
}

class _HistoryCarState extends State<HistoryCar> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _reservationStream = FirebaseFirestore.instance
        .collection('reservations')
        .where('userId', isEqualTo: user.uid)
        .where('state', isEqualTo: 3)
        .snapshots();
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: _reservationStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                  child: Text('Something went wrong ${snapshot.error}',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700, fontSize: 18)));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: dBlue),
              );
            }

            if (snapshot.data?.size == 0) {
              return Center(
                child: Text('Aucune Reservation en Expirée',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700, fontSize: 18)),
              );
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  final String id = document.id;
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return buildCar(data);
                }).toList(),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
              );
            }
          }),
    );
  }
}

Widget buildCar(data) => Container(
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
              image: NetworkImage(data['car']['image']),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: data['state'] == 3
                          ? Colors.red
                          : data['state'] == 2
                              ? dBlue
                              : Colors.amber,
                    ),
                    child: Text(
                      data['state'] == 3
                          ? "Expiré"
                          : data['state'] == 2
                              ? "En Service"
                              : "En Attente",
                      style:
                          GoogleFonts.nunito(color: Colors.white, fontSize: 12),
                    ),
                  ))
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${data['car']['name']}",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                "${DateFormat('dd/MM/yyyy').format((data['start_date'] as Timestamp).toDate())} - ${DateFormat('dd/MM/yyyy').format((data['end_date'] as Timestamp).toDate())}",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
              Text(
                "${data['amount']} XFA",
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
