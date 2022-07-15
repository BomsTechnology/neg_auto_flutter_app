import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/main.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  Stream<QuerySnapshot> _faqsStream =
      FirebaseFirestore.instance.collection('faqs').snapshots();
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
            "Faqs",
            style: GoogleFonts.nunito(color: dGray),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _faqsStream,
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
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ExpansionTile(
                      title: Text(
                        "${data['question']}",
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "${data['response']}",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.nunito(),
                          ),
                        )
                      ],
                    );
                  }).toList(),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
                );
              }
            }));
  }
}
