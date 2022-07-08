import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/main.dart';
import 'package:neg/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final Stream<QuerySnapshot> _carsStream =
      FirebaseFirestore.instance.collection('cars').snapshots();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _carsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          return GridView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                final String id = document.id;
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
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
                          builder: (context) => DetailPage(
                            id: id,
                          ),
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
                            child: Image.network(
                              data['image'],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['name'],
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
              }).toList(),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 8,
              ));
        },
      ),
    );
  }
}
