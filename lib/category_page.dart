import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/detail_page.dart';
import 'package:neg/main.dart';

class CategoryPage extends StatefulWidget {
  final DocumentSnapshot category;
  const CategoryPage({required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _carsStream = FirebaseFirestore.instance
        .collection('cars')
        .where('state', isEqualTo: 1)
        .where('category.id', isEqualTo: widget.category.id)
        .snapshots();
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
          "Nos ${widget.category['name']}",
          style: GoogleFonts.nunito(color: dGray),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _carsStream,
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
