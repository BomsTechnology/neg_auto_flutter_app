import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:neg/Utils.dart';
import 'package:neg/main.dart';
import 'package:neg/modal/message.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String? userId;
  // Stream<QuerySnapshot<Map<String, dynamic>>>? _messagesStream;

  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          userId = doc.id;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _messagesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("messages")
        .orderBy("date")
        .snapshots();
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            color: dBlue,
            child: Text(
              "Chat Assistance",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _messagesStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      child: Text('Aucun Message',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700, fontSize: 18)),
                    );
                  } else {
                    final List<QueryDocumentSnapshot<Object?>> messages =
                        snapshot.data?.docs ?? [];
                    return GroupedListView(
                      elements: messages,
                      reverse: true,
                      order: GroupedListOrder.DESC,
                      useStickyGroupSeparators: true,
                      floatingHeader: true,
                      groupHeaderBuilder: (QueryDocumentSnapshot messageDoc) =>
                          SizedBox(
                        height: 40,
                        child: Center(
                          child: Card(
                            color: dBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                DateFormat.yMMMMd().format(
                                    (messageDoc['date'] as Timestamp).toDate()),
                                style: GoogleFonts.nunito(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      groupBy: (QueryDocumentSnapshot messageDoc) => DateTime(
                        (messageDoc['date'] as Timestamp).toDate().year,
                        (messageDoc['date'] as Timestamp).toDate().month,
                        (messageDoc['date'] as Timestamp).toDate().day,
                      ),
                      padding: const EdgeInsets.all(10),
                      itemBuilder:
                          (context, QueryDocumentSnapshot messageDoc) =>
                              Container(
                        padding: messageDoc['isSentByMe']
                            ? const EdgeInsets.only(left: 50)
                            : const EdgeInsets.only(right: 50),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: messageDoc['isSentByMe']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 5,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              color: messageDoc['isSentByMe']
                                  ? dBlue
                                  : Colors.white,
                              borderRadius: messageDoc['isSentByMe']
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))
                                  : BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                            ),
                            child: Text(
                              messageDoc['content'],
                              style: GoogleFonts.nunito(
                                  color: messageDoc['isSentByMe']
                                      ? Colors.white
                                      : dGray),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 65),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: messageFiled()),
        ],
      ),
    );
  }

  Widget messageFiled() => Form(
        key: formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: messageController,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) =>
                    value != null && value.length < 1 ? "Message vide" : null,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelText: "Ecrivez votre message ici...",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 0),
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
                onTap: sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dBlue,
                  ),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
      );

  Future sendMessage() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    FocusScope.of(context).unfocus();
    try {
      final messageRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("messages");

      messageRef.add({
        'content': messageController.text.trim(),
        'isSentByMe': true,
        'state': true,
        'date': DateTime.now(),
      });
      messageController.text = " ";
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }
}
