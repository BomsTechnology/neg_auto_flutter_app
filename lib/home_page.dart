import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: MySearchDelegate());
                    },
                    icon: const Icon(Icons.search)),
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

  Widget builHeader(BuildContext context) => Material(
        color: dBlue,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
            width: double.infinity,
            child: Column(
              children: [
                const FaIcon(
                  FontAwesomeIcons.circleUser,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Boms Technology",
                  style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "bomstechnology@gmail.com",
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
  Widget builMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text("Favourites"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.workspaces_outline),
              title: const Text("Workflow"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text("Updates"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("Plugins"),
              onTap: () {},
            ),
            const Divider(
              color: dGray,
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text("Notifications"),
              onTap: () {},
            ),
          ],
        ),
      );
}