import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/widgets/joindregroupeform_widget.dart';

class JoinGroupe extends StatelessWidget {
  JoinGroupe({Key? key}) : super(key: key);

  static const String routeName = "/joindregroupe";

  _submitJoinGroupForm(
      String emailUserAjoute,
      BuildContext context
      ) async {
    String idAncientGroupe = "";
    String idGroupeUser = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => value.data()!['idGroupe']);;

    await FirebaseFirestore.instance.collection('users').get().then((values) => values.docs.forEach((element) async {
      if (element.data()['email'] == emailUserAjoute) {
        FirebaseFirestore.instance.collection('users').doc(element.id).get().then((value)
        async {
          idAncientGroupe = value.data()!['idGroupe'];

          FirebaseFirestore.instance
              .collection('groupes')
              .doc(idAncientGroupe)
              .update({
            'membres': FieldValue.arrayRemove([element.id]),
          });

          FirebaseFirestore.instance
              .collection('groupes')
              .doc(idGroupeUser)
              .update({
            'membres': FieldValue.arrayUnion([element.id]),
          });

          FirebaseFirestore.instance.collection('users').doc(element.id).update({
            'idGroupe': idGroupeUser,
          });

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Utilisateur ajouté au groupe!")));

        });
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ajouter un utilisateur"),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Vous voulez ajouter un utilisateur à votre groupe ?"),
                JoinGroupForm(_submitJoinGroupForm),
              ],
            ),
        )
    );
  }
}
