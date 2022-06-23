import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neg/login_page.dart';
import 'package:neg/home_page.dart';

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
      body: SingleChildScrollView(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(15),
                  ),
                  child: Image.asset(
                    'assets/images/icone/google.png',
                    height: 30,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: dBlue,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.facebook,
                    size: 30,
                  ),
                ),
              ],
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
  var _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10), border: InputBorder.none),
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
            child: TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10), border: InputBorder.none),
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
            child: TextField(
              obscureText: _obscureText,
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
