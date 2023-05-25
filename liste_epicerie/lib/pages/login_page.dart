
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/providers/epiceriebd.dart';
import 'package:liste_epicerie/widgets/auth_widget.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;

  Future<void> _submitAuthForm(
      String email,
      String password,
      String username,
      bool isLogin,
      BuildContext context,
      ) async {
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        var groupeDoc = FirebaseFirestore.instance
            .collection('groupes')
            .doc();
        groupeDoc.set({
          'membres': [authResult.user!.uid],
          'nbListe': 0,
        });
        
        FirebaseFirestore.instance
            .collection('epicerieGroupe')
            .doc(groupeDoc.id)
            .collection('list_0').doc('Autre').set({
          'date': '',
        });

        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid).set({
          'username': username,
          'email': email,
          'idGroupe': groupeDoc.id,
        });
      }

    } on FirebaseException catch (e) {
      var message = "Un erreur s'est produite.";

      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (err) {
      print("Erreur non géré $err");
    } finally {
      EpicerieBD.createDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: AuthFormWidget(_submitAuthForm),
    );
  }
}
