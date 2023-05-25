import 'package:flutter/material.dart';
import 'package:liste_epicerie/models/article.dart';
import 'package:liste_epicerie/providers/articlelisteusage.dart';
import 'package:liste_epicerie/widgets/articleepicerie_widget.dart';
import 'package:provider/provider.dart';


class FaireEpicerie extends StatefulWidget {
  const FaireEpicerie({Key? key}) : super(key: key);

  static const routeName = "/faireepicerie";

  @override
  State<FaireEpicerie> createState() => _FaireEpicerieState();
}

class _FaireEpicerieState extends State<FaireEpicerie> {

  @override
  void initState() {
    super.initState();

    Provider.of<ArticleUsage>(context, listen: false).loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartGrocery',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Article à acheter'),
          actions: [
            DropdownButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: [
                DropdownMenuItem(
                  value: "retour",
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text("Retour"),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: "achete",
                  child: Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text("Terminer"),
                    ],
                  ),
                ),
              ],
              onChanged: (item) {
                switch (item) {
                  case "retour":
                    Navigator.of(context).pop();
                    break;
                  case "achete":
                    Provider.of<ArticleUsage>(context, listen: false).epicerieAchete();
                    Navigator.of(context).pop();
                    break;
                }
              },
            ),
          ],
        ),

        body: Consumer<ArticleUsage>(
            builder: (context, epiceries, child){
              return RefreshIndicator(
                onRefresh: () async {
                  await epiceries.loadArticles();
                },
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final Article article = epiceries.articles.removeAt(oldIndex);
                      epiceries.articles.insert(newIndex, article);
                    });
                  },
                  children: epiceries.articles.map((article) {

                    if (article.status == Status.achete) {
                      return Container(key: ValueKey(article.id),);
                    }

                    return SingleChildScrollView(
                      key: ValueKey(article.id),
                      child: Dismissible(
                          key: ValueKey(article.id),
                          confirmDismiss: (direction) async {
                            epiceries.deleteArticle(article.id);
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
                          child: ArticleEpicerie(article)
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
      ),
    );
  }
}
