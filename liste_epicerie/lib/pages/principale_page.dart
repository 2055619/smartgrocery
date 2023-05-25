
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/pages/articleglobaux_page.dart';
import 'package:liste_epicerie/pages/creerarticle_page.dart';
import 'package:liste_epicerie/pages/faireepicerie_page.dart';
import 'package:liste_epicerie/pages/historiqueepicerie_page.dart';
import 'package:liste_epicerie/pages/maliste_page.dart';
import 'package:liste_epicerie/widgets/menugauche_widget.dart';

class Principale extends StatefulWidget {
  Principale({Key? key}) : super(key: key);

  static const routeName = "/principale";

  @override
  State<Principale> createState() => _PrincipaleState();
}

class _PrincipaleState extends State<Principale> {
  int currentIndex = 0;

  final pages = [
    const ArticleGlobauxPage(),
    const ListeUsage(),
    const Historique(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SmartGrocery"),
        actions: [
          DropdownButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: "logout",
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text("Logout"),
                    ],
                  ),
                ),
              ],
              onChanged: (item) {
                switch (item) {
                  case "logout":
                    FirebaseAuth.instance.signOut();
                    break;
                }
              })
        ],
      ),
      drawer: Drawer(
        child: MenuGauche(),
      ),
      backgroundColor: Colors.grey[200],
      body: pages[currentIndex],
      floatingActionButton: currentIndex != 2 ? FloatingActionButton(
        onPressed: () {
          if(currentIndex == 0){
            Navigator.of(context).pushNamed(CreerArticle.routeName);
          }
          else if(currentIndex == 1){
            Navigator.of(context).pushNamed(FaireEpicerie.routeName);
          }
        },
        child: currentIndex == 0 ? Icon(Icons.add) : Icon(Icons.shopping_bag_outlined),
      ) : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Ma liste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}
