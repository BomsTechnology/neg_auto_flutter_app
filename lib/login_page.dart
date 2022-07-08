import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/Utils.dart';
import 'package:neg/main.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neg/register_page.dart';
import 'package:neg/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              return LoginScreen();
            }
            ;
          }),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  "Connexion",
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Heureux de vous revoir, connectez-vous",
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: dGray,
              ),
            ),
          ),
          FormLogin(),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
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
                        "Connexion avec Google",
                        style: GoogleFonts.nunito(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: dGray),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // ElevatedButton(
                //   onPressed: () {},
                //   style: ElevatedButton.styleFrom(
                //     primary: dBlue,
                //     shape: const StadiumBorder(),
                //     padding: const EdgeInsets.all(10),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       const FaIcon(
                //         FontAwesomeIcons.facebook,
                //         size: 30,
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       Text(
                //         "Connexion avec facebook",
                //         style: GoogleFonts.nunito(
                //             fontSize: 19, fontWeight: FontWeight.w700),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Vous n'avez pas de compte ? ",
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
                        builder: (context) => RegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    "inscrivez vous",
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

class FormLogin extends StatefulWidget {
  const FormLogin({Key? key}) : super(key: key);

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
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
                height: 10,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Mot de passe oublie ?",
                  style: GoogleFonts.nunito(
                    color: dBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("Se connecter",
                      style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    primary: dBlue,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(13),
                  ),
                  onPressed: login,
                ),
              )
            ],
          ),
        ));
  }

  Future login() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      // var cuser;
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // final user = credential.user;

      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .where("userId", isEqualTo: user?.uid)
      //     .get()
      //     .then(
      //   (QuerySnapshot querySnapshot) {
      //     querySnapshot.docs.forEach((doc) {
      //       var cuser = doc.data();
      //       print(cuser);
      //     });
      //   },
      //   onError: (e) => Utils.showSnackBar("Error completing: $e"),
      // );

      // if (cuser?.state == 1) {
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      // } else {
      //   FirebaseAuth.instance.signOut();
      //   throw FirebaseAuthException(code: 'deactivation-account');
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Navigator.of(context, rootNavigator: true).pop();
        Utils.showSnackBar('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Navigator.of(context, rootNavigator: true).pop();
        Utils.showSnackBar('Wrong password provided for that user.');
      } else if (e.code == 'deactivation-account') {
        Utils.showSnackBar('votre compte à été désactiver');
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }
}
