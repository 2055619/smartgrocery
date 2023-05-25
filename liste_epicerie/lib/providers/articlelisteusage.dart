

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/models/article.dart';
import 'package:liste_epicerie/models/epicerie.dart';
import 'package:liste_epicerie/providers/epiceriebd.dart';


class ArticleUsage with ChangeNotifier {
  List<Article> _articles = [];
  List<Epicerie> _epicerie = [];
  late String _idGroupe;
  late int _numListe;
  static EpicerieBD epicerieBD = EpicerieBD();

  List<Article> get articles {
    return _articles;
  }

  get length => _articles.length;

  List<Epicerie> get epicerie {
    return _epicerie;
  }

  get idGroupe => _idGroupe;

  Future<bool> get isConnecte async => await Connectivity().checkConnectivity() != ConnectivityResult.none;

  findGroupAndList() async {
    _idGroupe = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) => value.data()!['idGroupe']);
    _numListe = await FirebaseFirestore.instance.collection('groupes').doc(_idGroupe).get().then((value) => value.data() != null ? value.data()!['nbListe'] : 0);
  }

  loadArticles() async {
    await isConnecte ? await loadFromFirebase() : await loadFromPhone();
  }

  loadFromPhone() async {
    _articles = [];
    _articles = await epicerieBD.loadArticles();
    notifyListeners();
  }

  loadFromFirebase() async {
    await findGroupAndList();
    checkLastShopping();

    _articles = [];


    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance
        .collection('epicerieGroupe')
        .doc(_idGroupe)
        .collection('list_$_numListe').get();

    for (var doc in querySnapshot.docs) {
      if (doc.id == 'Autre') continue;
      Article article = Article.fromMap(doc.data());

      _articles.add(article);
      epicerieBD.addArticle(article);
    }

    notifyListeners();
  }

  checkLastShopping() async {
    final articles = await epicerieBD.loadArticles();

    if(articles.isEmpty) return;

    if(articles.every((element) => element.status == Status.achete)) {
      epicerieBD.setEpicerieAchete();
      epicerieAchete();
    }
  }

  Future<void> addArticle(Article article) async {

    if(await isConnecte){
      await findGroupAndList();

      FirebaseFirestore.instance
          .collection('epicerieGroupe')
          .doc(_idGroupe)
          .collection('list_$_numListe')
          .doc(article.id)
          .set({
        '_id': article.id,
        'product_name': article.product_name,
        'allergens': article.allergens,
        'brands': article.brands,
        'categories': article.categories,
        'creator': await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((value) => value.data()!['username']),
        'image_url': article.image_url,
        'nutriscore_grade': article.nutriscore_grade,
        'url': article.url,
      });
    }

    _articles.add(article);
    epicerieBD.addArticle(article);

    notifyListeners();
  }

  Future<void> deleteArticle(id) async {
    await isConnecte ? FirebaseFirestore.instance
        .collection('epicerieGroupe')
        .doc(_idGroupe)
        .collection('list_$_numListe')
        .doc(id).delete() : null;

    epicerieBD.deleteArticle(id);
    _articles.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  bool epicerieTermine(){
    for(int i=0; i<_articles.length; i++){
      if(_articles[i].status != Status.achete){
        return false;
      }
    }
    return true;
  }

  loadListesEpicerie() async {
    _epicerie = [];

    await findGroupAndList();

    for(int i=0; i<=_numListe; i++){
      Epicerie epicerie = Epicerie("list_$i", [], '');

      await FirebaseFirestore.instance
          .collection("epicerieGroupe")
          .doc(_idGroupe)
          .collection("list_$i")
          .get().then((value) => value.docs.map((e) => {
        epicerie.articles.add(Article.fromMap(e.data())),
      }));

      _epicerie.add(epicerie);

      FirebaseFirestore.instance.collection('epicerieGroupe').doc(_idGroupe).collection('list_$i').doc('Autre').get().then((value) => {
        epicerie.date = value.data() == null ? "Pas achevé" : value.data()!['dateAchat'],
      });
    }

    notifyListeners();
  }

  articleAchete(String idArticle) async {

    await isConnecte ? FirebaseFirestore.instance.collection('epicerieGroupe').doc(_idGroupe).collection('list_$_numListe').doc(idArticle).update({
      'status': Status.achete.toString(),
      'dateAchat': DateTime.now().toString(),
    }) : null;

    _articles.firstWhere((element) => element.id == idArticle).status = Status.achete;
    epicerieBD.setArticleAchete(idArticle);

    notifyListeners();

    if(epicerieTermine()){
      terminerEpicerie();
    }
  }

  articleNonTrouve(String idArticle){
    FirebaseFirestore.instance.collection('epicerieGroupe').doc(_idGroupe).collection('list_$_numListe').doc(idArticle).update({
      'status': Status.nontrouve.toString(),
      'dateAchat': '',
    });

    _articles.firstWhere((element) => element.id == idArticle).status = Status.nontrouve;

    notifyListeners();
  }

  epicerieAchete() async {

    await isConnecte ? _articles.map((article) => {
      article.status = Status.achete,
      articleAchete(article.id),
    }):
    epicerieBD.setEpicerieAchete();

    terminerEpicerie();
  }

  terminerEpicerie(){
    FirebaseFirestore.instance.collection('epicerieGroupe').doc(_idGroupe).collection('list_$_numListe').doc('Autre').set({
      'dateAchat': DateTime.now().toString(),
    });
    FirebaseFirestore.instance.collection('groupes').doc(_idGroupe).update({
      'nbListe': ++_numListe,
    });

    _articles = [];

    notifyListeners();
  }



}