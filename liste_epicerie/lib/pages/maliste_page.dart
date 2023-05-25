
import 'package:flutter/material.dart';
import 'package:liste_epicerie/models/article.dart';
import 'package:liste_epicerie/providers/articlelisteusage.dart';
import 'package:liste_epicerie/widgets/article_widget.dart';
import 'package:provider/provider.dart';

class ListeUsage extends StatefulWidget {
  const ListeUsage({Key? key}) : super(key: key);

  @override
  State<ListeUsage> createState() => _ListeUsageState();
}

class _ListeUsageState extends State<ListeUsage> {

  @override
  void initState() {
    super.initState();

    Provider.of<ArticleUsage>(context, listen: false).loadArticles();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<ArticleUsage>(
        builder: (context, articleUser, child){
          return RefreshIndicator(
            onRefresh: () async {
              await articleUser.loadArticles();
              },
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Article article = articleUser.articles.removeAt(oldIndex);
                  articleUser.articles.insert(newIndex, article);
                });
              },
              children: articleUser.articles.map((article) {
                return SingleChildScrollView(
                  key: ValueKey(article.id),
                  child: Dismissible(
                    key: ValueKey(article.id),
                    confirmDismiss: (direction) async {
                      articleUser.deleteArticle(article.id);
                      return null;
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ArticleWidget(article: article)
                  ),
                );
              }).toList(),
            ),
          );
    });
  }
}