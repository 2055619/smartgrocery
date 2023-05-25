import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liste_epicerie/models/article.dart';
import 'package:liste_epicerie/providers/articlelisteusage.dart';
import 'package:liste_epicerie/widgets/article_widget.dart';
import 'package:provider/provider.dart';

class ListeArticle extends StatelessWidget {
  const ListeArticle(this.idListe, this.idGroupe, {Key? key}) : super(key: key);

  final String idListe;
  final String idGroupe;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('epicerieGroupe').doc(idGroupe).collection(idListe).snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final myData = snapshot.data as QuerySnapshot<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: myData.docs.length,
            itemBuilder: (context, index) {

              return SingleChildScrollView(
                child: Dismissible(
                    key: ValueKey(Article.fromMap(myData.docs[index].data()).id),
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
        }
      ),
    );
  }
}
