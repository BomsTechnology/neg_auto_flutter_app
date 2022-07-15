import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neg/account_page.dart';
import 'package:neg/faq_page.dart';
import 'package:neg/main.dart';
import 'package:neg/page/car.dart';
import 'package:neg/page/home.dart';
import 'package:neg/page/message.dart';
import 'package:neg/page/reservation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 1;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  final screens = [ReservationPage(), HomeView(), CarPage(), MessagePage()];
  final items = <Widget>[
    FaIcon(FontAwesomeIcons.clipboardList, size: 18),
    FaIcon(FontAwesomeIcons.home, size: 18),
    FaIcon(FontAwesomeIcons.car, size: 18),
    FaIcon(FontAwesomeIcons.message, size: 18)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dBlue,
      child: SafeArea(
        top: false,
        child: ClipRect(
          child: Scaffold(
            extendBody: true,
            appBar: AppBar(
              backgroundColor: dBlue,
              title: Text(
                "Neg Auto Services",
                style: GoogleFonts.nunito(
                    fontSize: 20, fontWeight: FontWeight.w700),
              ),
              centerTitle: true,
              elevation: 0,
              actions: [
                // IconButton(
                //   onPressed: () {
                //     showSearch(context: context, delegate: MySearchDelegate());
                //   },
                //   icon: const Icon(Icons.search),
                // ),
              ],
            ),
            body: IndexedStack(
              index: index,
              children: screens,
            ),
            drawer: NavigationDrawer(),
            bottomNavigationBar: Theme(
                data: Theme.of(context)
                    .copyWith(iconTheme: IconThemeData(color: Colors.white)),
                child: CurvedNavigationBar(
                  key: navigationKey,
                  color: dBlue,
                  height: 60,
                  items: items,
                  index: index,
                  backgroundColor: Colors.transparent,
                  onTap: (index) => setState(() => this.index = index),
                )),
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(
          Icons.arrow_back,
        ),
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(
            Icons.clear,
          ),
        )
      ];

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            builHeader(context),
            builMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget builHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Material(
      color: dBlue,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountPage(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
          width: double.infinity,
          child: Column(
            children: [
              user.photoURL != null
                  ? CircleAvatar(
                      radius: 40.0,
                      backgroundImage: NetworkImage("${user.photoURL}"),
                    )
                  : const FaIcon(
                      FontAwesomeIcons.circleUser,
                      size: 80,
                      color: Colors.white,
                    ),
              const SizedBox(
                height: 12,
              ),
              Text(
                user.displayName != null ? user.displayName! : '',
                style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                user.email!,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget builMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text("Mon Compte", style: GoogleFonts.nunito()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text("Notifications", style: GoogleFonts.nunito()),
              onTap: () {},
            ),
            const Divider(
              color: dGray,
            ),
            ListTile(
              leading: const Icon(Icons.question_mark_rounded),
              title: Text("Faqs", style: GoogleFonts.nunito()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FaqPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text("Règles de confidentialité",
                  style: GoogleFonts.nunito()),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.file_copy_outlined),
              title: Text("A propos", style: GoogleFonts.nunito()),
              onTap: () {},
            ),
            const Divider(
              color: dGray,
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text("Se Deconnecter", style: GoogleFonts.nunito()),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(),
                  ),
                );
              },
            ),
          ],
        ),
      );
}
