// import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/Utils.dart';
import 'package:neg/main.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User user = FirebaseAuth.instance.currentUser!;
  bool onEdit = false;
  bool loading = false;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordontroller = TextEditingController();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: user.photoURL == null
                    ? Image.asset(
                        "assets/images/icone/logo.png",
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        "${user.photoURL}",
                        fit: BoxFit.cover,
                      ),
              ),
              actions: [
                user.photoURL == null
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            onEdit = !onEdit;
                          });
                        },
                        icon: Icon(Icons.edit_note_rounded),
                      )
                    : Container()
              ],
            ),
          ];
        },
        body: onEdit ? editForm() : profile(),
      ),
    );
  }

  Widget profile() => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() {
                    onEdit = !onEdit;
                  }),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(7),
                    primary: dBlue,
                    shape: const StadiumBorder(),
                  ),
                  child: Row(children: [
                    Text("Editer le profil"),
                    SizedBox(width: 5),
                    Icon(Icons.edit_note_rounded)
                  ]),
                )
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(
              "Nom",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w100, fontSize: 20),
            ),
            subtitle: Text(
              "${user.displayName}",
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold, fontSize: 23, color: dGray),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(
              "Email",
              style:
                  GoogleFonts.nunito(fontWeight: FontWeight.w100, fontSize: 20),
            ),
            subtitle: Text(
              "${user.email}",
              style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold, fontSize: 23, color: dGray),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.phone),
          //   title: Text(
          //     "Téléphone",
          //     style:
          //         GoogleFonts.nunito(fontWeight: FontWeight.w100, fontSize: 20),
          //   ),
          //   subtitle: Text(
          //     "${user.phoneNumber}",
          //     style: GoogleFonts.nunito(
          //         fontWeight: FontWeight.bold, fontSize: 23, color: dGray),
          //   ),
          // ),
          const Divider(
            color: dGray,
          ),
        ],
      );

  Widget editForm() {
    nameController.text = user.displayName!;
    emailController.text = user.email!;

    Future selectFile() async {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      setState(() {
        pickedFile = result.files.first;
      });
    }

    Future edit() async {
      final isValid = formKey.currentState!.validate();
      if (!isValid) return;
      setState(() {
        loading = true;
      });
      try {
        await user.updateDisplayName(nameController.text.trim());
        if (passwordontroller.text.trim() != "") {
          // await user.reauthenticateWithCredential(FirebaseAuth.instance);
          await user.updatePassword(passwordontroller.text.trim());
          passwordontroller.clear();
        }
        if (pickedFile != null) {
          final path =
              "avatar/${DateTime.now().millisecondsSinceEpoch}_${pickedFile!.name}";

          final file = File(pickedFile!.path!);

          final ref = FirebaseStorage.instance.ref().child(path);
          await ref.putFile(file);

          final urlDownload = await ref.getDownloadURL();

          await user.updatePhotoURL(urlDownload);
        }
      } catch (e) {
        print(e.toString());
        Utils.showSnackBar(e.toString());
      }
      setState(() {
        user = FirebaseAuth.instance.currentUser!;
        onEdit = false;
        loading = false;
      });
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                "Mettre à jour votre profil",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w700,
                  color: dGray,
                  fontSize: 20,
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
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value != null && value.length > 0 ? null : 'Champ requis',
                  decoration: InputDecoration(
                      hintStyle: GoogleFonts.nunito(color: Colors.grey),
                      hintText: "Nom complet",
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
                  enabled: false,
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: const TextStyle(color: Colors.grey),
                  validator: (value) =>
                      value != null && value.length > 0 ? null : 'Champ requis',
                  decoration: InputDecoration(
                      hintStyle: GoogleFonts.nunito(color: Colors.grey),
                      hintText: "Adresse email",
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 15),
              // Container(
              //   padding: const EdgeInsets.only(left: 5),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //           color: Colors.grey.shade300,
              //           blurRadius: 5,
              //           offset: Offset(0, 3)),
              //     ],
              //   ),
              //   child: TextFormField(
              //     controller: passwordontroller,
              //     textInputAction: TextInputAction.done,
              //     decoration: InputDecoration(
              //         hintStyle: GoogleFonts.nunito(color: Colors.grey),
              //         hintText: "Mot de passe",
              //         contentPadding: EdgeInsets.all(10),
              //         border: InputBorder.none),
              //   ),
              // ),
              GestureDetector(
                onTap: selectFile,
                child: DottedBorder(
                  color: dBlue,
                  strokeWidth: 1,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        pickedFile != null
                            ? Container(
                                width: 50,
                                height: 50,
                                child: Image.file(
                                  File(pickedFile!.path!),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.file_upload_outlined,
                                color: dBlue,
                                size: 50,
                              ),
                        const SizedBox(height: 5),
                        Text(
                          pickedFile != null
                              ? pickedFile!.name
                              : "changez votre avatar",
                          style: GoogleFonts.nunito(color: dBlue),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
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
                  onPressed: edit,
                  child: loading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Mettre à jour",
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
        ),
      ),
    );
  }
}
