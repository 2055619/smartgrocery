import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/pages/creerarticle_page.dart';
import 'package:liste_epicerie/pages/faireepicerie_page.dart';
import 'package:liste_epicerie/pages/joindregroupe_page.dart';

class MenuGauche extends StatelessWidget {
  const MenuGauche({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Text(
              'SmartGrocery',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text('Ajouter au groupe'),
          leading: Icon(Icons.group),
          onTap: () {
            Navigator.of(context).pushNamed(JoinGroupe.routeName);
          },
        ),
        ListTile(
          title: Text('Ajouter un article'),
          leading: Icon(Icons.add),
          onTap: () {
            Navigator.pushNamed(context, CreerArticle.routeName);
          },
        ),
        ListTile(
          title: Text('Faire l\'épicerie'),
          leading: Icon(Icons.shopping_bag_outlined),
          onTap: () {
            Navigator.pushNamed(context, FaireEpicerie.routeName);
          },
        ),

        Spacer(),
        ListTile(
          title: Text('Déconnexion'),
          leading: Icon(Icons.exit_to_app),
          iconColor: Colors.red,
          onTap: () => FirebaseAuth.instance.signOut(),
        ),
      ],
    );
  }
}
