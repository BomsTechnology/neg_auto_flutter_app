import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/Utils.dart';
import 'package:neg/main.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neg/login_page.dart';
import 'package:neg/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return RegisterScreen();
            }
            ;
          }),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, bottom: 24),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: dBlue,
            child: Column(
              children: [
                Text(
                  "Neg Auto Services",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "Inscription",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Entrez vos coordonées pour rejoindre la team",
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: dGray,
            ),
          ),
          FormRegister(),
          Text(
            "Ou",
            style:
                GoogleFonts.nunito(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.all(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/icone/google.png',
                    height: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "S'inscrire avec Google",
                    style: GoogleFonts.nunito(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: dGray),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Déja inscrit ? ",
                style: GoogleFonts.nunito(
                  color: dGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Connectez vous",
                    style: GoogleFonts.nunito(
                      color: dBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class FormRegister extends StatefulWidget {
  const FormRegister({Key? key}) : super(key: key);

  @override
  State<FormRegister> createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var _obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nom Complet",
                style: GoogleFonts.nunito(
                  color: dGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
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
                  validator: (value) => value != null && value.length > 1
                      ? null
                      : 'Entrez votre nom',
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Adresse Email",
                style: GoogleFonts.nunito(
                  color: dGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      value != null && EmailValidator.validate(value)
                          ? null
                          : 'Entrez une adresse email valide',
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Mot de passe",
                style: GoogleFonts.nunito(
                  color: dGray,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: TextFormField(
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscureText,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? "Entrez au min. 6 caractères"
                      : null,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: dGray,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("S'inscrire",
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    primary: dBlue,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(13),
                  ),
                  onPressed: register,
                ),
              )
            ],
          ),
        ));
  }

  Future register() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = credential.user;
      await user?.updateDisplayName(nameController.text.trim());
      FirebaseFirestore.instance.collection('users').add({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'userId': user?.uid,
        'phone': "",
        'photo': "",
        'state': 1,
        'type': 'customer'
      });

      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      if (e.code == 'weak-password') {
        Utils.showSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Utils.showSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }
}
