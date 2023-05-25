import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/pages/creerarticle_page.dart';
import 'package:liste_epicerie/pages/faireepicerie_page.dart';
import 'package:liste_epicerie/pages/joindregroupe_page.dart';
import 'package:liste_epicerie/pages/login_page.dart';
import 'package:liste_epicerie/pages/principale_page.dart';
import 'package:liste_epicerie/providers/articlelisteusage.dart';
import 'package:liste_epicerie/providers/articlesglobaux.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.hasData){
          return MaterialApp(
            title: 'SmartGrocery',
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => ArticlesGlobaux(),
                ),
                ChangeNotifierProvider(
                  create: (context) => ArticleUsage(),
                ),
              ],
              child: MyHomePage(),
            ),
          );
        }

        return MaterialApp(
          title: 'SmartGrocery',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          home: Login(),
        );
      }
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: isConnected(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();

        }

        if (snapshot.data == false) {
          return ChangeNotifierProvider(
            create: (context) => ArticlesGlobaux(),
            child: MaterialApp(
              title: 'SmartGrocery',
              theme: ThemeData(
                primarySwatch: Colors.deepOrange,
              ),
              home: Center(
                child: FaireEpicerie(),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            title: 'SmartGrocery',
            theme: ThemeData(
              primarySwatch: Colors.deepOrange,
            ),
            home: Center(
              child: Text("PROBLEME!!!"),
            ),
          );
        }

        return MaterialApp(
          title: 'SmartGrocery',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          home: Principale(),
          routes: {
            CreerArticle.routeName: (context) => CreerArticle(),
            Principale.routeName: (context) => Principale(),
            JoinGroupe.routeName: (context) => JoinGroupe(),
            FaireEpicerie.routeName: (context) => FaireEpicerie(),
          },
        );
      }
    );
  }

  Future<bool> isConnected() async {
    return await Connectivity().checkConnectivity() != ConnectivityResult.none;
  }
}