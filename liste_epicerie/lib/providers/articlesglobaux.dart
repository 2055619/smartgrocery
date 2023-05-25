import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liste_epicerie/models/article.dart';


// Element d'un article: _id,product_name,allergens,brands,categories,creator,image_url,nutriscore_grade,url

class ArticlesGlobaux with ChangeNotifier {
  final String urlApi = "https://world.openfoodfacts.org/api/v2/search?code=";

  Future<Article> creeParScan(String barcodeScanRes) async {
    var lien = Uri.parse('$urlApi$barcodeScanRes&fields=_id,product_name,allergens,brands,categories,creator,image_url,nutriscore_grade,url');

    final reponse = await http.get(lien);
    var jsonPayload = json.decode(utf8.decode(reponse.bodyBytes));

    Article article = Article.fromMap(jsonPayload['products'][0]);

    await ajoutGlobaleFirebase(article);

    return article;
  }

  Future<void> ajoutArticle(
    String product_name,
    String allergens,
    String brands,
    String categories,
    String creator,
    String nutriscore_grade,
    String url,
    XFile image,
  ) async {

    String id = DateTime.now().toString();
    String image_url = "";

    await FirebaseStorage.instance
        .ref()
        .child('articles_images/$id')
        .putFile(File(image.path),)
        .then((value) async {
          image_url = await value.ref.getDownloadURL();
          print("Image url1: $image_url");
        });

    final article = Article(
      id,
      product_name,
      allergens,
      brands,
      categories,
      creator,
      image_url,
      nutriscore_grade,
      url,
      Status.enAttente,
      '',
    );

    await ajoutGlobaleFirebase(article);
  }

  Future<void> ajoutGlobaleFirebase (Article article) async {

    FirebaseFirestore.instance
        .collection('articlesGlobaux')
        .doc(article.id).set({
      '_id': article.id,
      'product_name': article.product_name,
      'allergens': article.allergens,
      'brands': article.brands,
      'categories': article.categories,
      'creator': article.creator,
      'image_url': article.image_url,
      'nutriscore_grade': article.nutriscore_grade,
      'url': article.url,
      'status': article.status.toString(),
      'dateAchat': article.dateAchat,
    });
  }

  Future<List<String>> getCategories(String categorie) async {
    List<String> categories = [];
    await FirebaseFirestore.instance
        .collection('articlesGlobaux').get().then((value) => value.docs.forEach((element)
    {
        categories.addAll(element.data()['categories'].split(','));
    }));

    return categories;
  }

  Future<Article> getArticle(String id) async {
    final article = await FirebaseFirestore.instance
        .collection('articlesGlobaux')
        .doc(id)
        .get();

    return Article.fromMap(article.data()!);
  }
}