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
  Stream<QuerySnapshot> _carsStream = FirebaseFirestore.instance
      .collection('cars')
      .where('state', isEqualTo: 1)
      .snapshots();
  final Future<QuerySnapshot> _brandsStream = FirebaseFirestore.instance
      .collection('brands')
      .orderBy("name", descending: true)
      .get();
  final Future<QuerySnapshot> _categoriesStream = FirebaseFirestore.instance
      .collection('categories')
      .orderBy('name', descending: true)
      .get();
  String? selectBrandValue = "all";
  String? selectCategoryValue = "all";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: dBlue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FutureBuilder<QuerySnapshot>(
                    future: _categoriesStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Something went wrong',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data?.size == 0) {
                        return Center(
                          child: Text('Pas de categorie',
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w700, fontSize: 18)),
                        );
                      } else {
                        return Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectCategoryValue,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              onChanged: (value) => setState(() {
                                selectCategoryValue = value;
                              }),
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return DropdownMenuItem(
                                  child: Text(
                                    data['name'] == 'a'
                                        ? '-- Catégories --'
                                        : data['name'],
                                    style: GoogleFonts.nunito(),
                                  ),
                                  value: document.id,
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                    }),
                const SizedBox(width: 10),
                FutureBuilder<QuerySnapshot>(
                    future: _brandsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Something went wrong',
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18)));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.data?.size == 0) {
                        return Center(
                          child: Text('Pas de marque',
                              style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w700, fontSize: 18)),
                        );
                      } else {
                        return Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              value: selectBrandValue,
                              onChanged: (value) => setState(() {
                                selectBrandValue = value;
                              }),
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return DropdownMenuItem(
                                  child: Text(
                                    data['name'] == 'a'
                                        ? '-- Marques --'
                                        : data['name'],
                                    style: GoogleFonts.nunito(),
                                  ),
                                  value: document.id,
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                    }),
                const SizedBox(width: 10),
                SizedBox(
                  width: 35,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (selectBrandValue != 'all' &&
                            selectCategoryValue != 'all') {
                          _carsStream = FirebaseFirestore.instance
                              .collection('cars')
                              .where('state', isEqualTo: 1)
                              .where('brand.id', isEqualTo: selectBrandValue)
                              .where('category.id',
                                  isEqualTo: selectCategoryValue)
                              .snapshots();
                        } else if (selectBrandValue != 'all') {
                          _carsStream = FirebaseFirestore.instance
                              .collection('cars')
                              .where('state', isEqualTo: 1)
                              .where('brand.id', isEqualTo: selectBrandValue)
                              .snapshots();
                        } else if (selectCategoryValue != 'all') {
                          _carsStream = FirebaseFirestore.instance
                              .collection('cars')
                              .where('state', isEqualTo: 1)
                              .where('category.id',
                                  isEqualTo: selectCategoryValue)
                              .snapshots();
                        } else {
                          _carsStream = FirebaseFirestore.instance
                              .collection('cars')
                              .where('state', isEqualTo: 1)
                              .snapshots();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(5),
                        primary: Colors.white,
                        shape: const StadiumBorder()),
                    child: const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CarSection(
            carsStream: _carsStream,
          ),
        ],
      ),
    );
  }
}

class CarSection extends StatefulWidget {
  final Stream<QuerySnapshot> carsStream;
  const CarSection({required this.carsStream});

  @override
  State<CarSection> createState() => _CarSectionState();
}

class _CarSectionState extends State<CarSection> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: widget.carsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            if (snapshot.data?.size == 0) {
              return Center(
                child: Text('Aucun Véhicule',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700, fontSize: 18)),
              );
            } else {
              return GridView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
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
            }
          }),
    );
  }
}
