import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:neg/main.dart';
import 'package:neg/modal/message.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> messages = [
    Message(
      text:
          "Bonjour et bienvenue sur notre application ceci est le chat d'assistance c'est grace à cela que vous pourrez poser toutes vos questions et préoccupations, prendre et renseignements et bien d'autres :)",
      date: DateTime.now().subtract(const Duration(minutes: 1)),
      isSentByMe: false,
    ),
    Message(
      text: "Bonjour svp j'aimerais savoir comment reserver un véhicule",
      date: DateTime.now().subtract(const Duration(days: 1, minutes: 1)),
      isSentByMe: true,
    ),
    Message(
      text:
          "Bonjour M; Boms il est simple d'éffectuer une reservation grace à notre application vous identifier et selectionner la voiture de choix renseigner les critères de location(avec chauffeur & plein d'éssence) ensuite vous un dépôt sur l'un de nos numeros qui sont afficher et renseigner les champs requis",
      date: DateTime.now().subtract(const Duration(days: 1, minutes: 5)),
      isSentByMe: false,
    ),
    Message(
      text:
          "Votre reservation sera valider dans les brefs délais et vous pourrez entrer en possesion du véhicule.",
      date: DateTime.now().subtract(const Duration(days: 1, minutes: 6)),
      isSentByMe: false,
    ),
    Message(
      text: "Ok Merci",
      date: DateTime.now().subtract(const Duration(days: 1, minutes: 10)),
      isSentByMe: true,
    ),
    Message(
      text: "Bonjour c'est quoi l'ID de la transaction ?",
      date: DateTime.now().subtract(const Duration(days: 2, minutes: 6)),
      isSentByMe: true,
    ),
    Message(
      text:
          "Bonjour M. Boms l'ID de la transaction est l'identifiant que votre opérateur mobile vous envoi par message après une transaction.",
      date: DateTime.now().subtract(const Duration(days: 2, minutes: 10)),
      isSentByMe: false,
    ),
    Message(
      text: "Ahnnnn d'accord je vois!",
      date: DateTime.now().subtract(const Duration(days: 2, minutes: 20)),
      isSentByMe: true,
    ),
    Message(
      text: "Je viens d'éffectuer une réservation",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 10)),
      isSentByMe: true,
    ),
    Message(
      text: "Bonjour M. Boms patienter quelques minutes nous vérifions...",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 11)),
      isSentByMe: false,
    ),
    Message(
      text:
          "La réservation #R02015 à été enregistrer et valider avec succes, vous pouvez passez en agence récuperer le véhicule.",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 12)),
      isSentByMe: false,
    ),
    Message(
      text: "D'accord trés pratique votre application",
      date: DateTime.now().subtract(const Duration(days: 3, minutes: 15)),
      isSentByMe: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
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
            child: GroupedListView(
              elements: messages,
              reverse: true,
              order: GroupedListOrder.ASC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              groupHeaderBuilder: (Message message) => SizedBox(
                height: 40,
                child: Center(
                  child: Card(
                    color: dBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        DateFormat.yMMMMd().format(message.date),
                        style: GoogleFonts.nunito(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              groupBy: (Message message) => DateTime(
                message.date.year,
                message.date.month,
                message.date.day,
              ),
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, Message messsage) => Container(
                padding: messsage.isSentByMe
                    ? const EdgeInsets.only(left: 50)
                    : const EdgeInsets.only(right: 50),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Align(
                  alignment: messsage.isSentByMe
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
                      color: messsage.isSentByMe ? dBlue : Colors.white,
                      borderRadius: messsage.isSentByMe
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
                      messsage.text,
                      style: GoogleFonts.nunito(
                          color: messsage.isSentByMe ? Colors.white : dGray),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 65),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: messageFiled()),
        ],
      ),
    );
  }

  Widget messageFiled() => Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dBlue,
            ),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      );
}
