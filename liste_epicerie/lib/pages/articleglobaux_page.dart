
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/models/article.dart';
import 'package:liste_epicerie/providers/articlelisteusage.dart';
import 'package:liste_epicerie/widgets/article_widget.dart';
import 'package:provider/provider.dart';

class ArticleGlobauxPage extends StatefulWidget {
  const ArticleGlobauxPage({Key? key}) : super(key: key);

  @override
  State<ArticleGlobauxPage> createState() => _ArticleGlobauxPageState();
}

class _ArticleGlobauxPageState extends State<ArticleGlobauxPage> {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('articlesGlobaux').snapshots(),
        builder: (ctx, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final myData = snapshot.data as QuerySnapshot<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: myData.docs.length,
            itemBuilder: (context, index) {
              if (myData.docs[index].data().containsKey("product_name") == false) {
                return const Text("Pas de texte");
              }
              return SingleChildScrollView(
                child: Dismissible(
                    key: ValueKey(myData.docs[index].id),
                    confirmDismiss: (direction) async {
                      Provider.of<ArticleUsage>(context, listen: false).addArticle(Article.fromMap(myData.docs[index].data()));
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    child: ArticleWidget(article: Article.fromMap(myData.docs[index].data()))
                ),
              );
            },
          );
        },
    );
  }
}