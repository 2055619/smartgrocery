import 'package:flutter/material.dart';
import 'package:liste_epicerie/models/article.dart';
import 'package:liste_epicerie/providers/articlelisteusage.dart';
import 'package:provider/provider.dart';

class ArticleEpicerie extends StatelessWidget {
  const ArticleEpicerie(this.article, {Key? key}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: article.status == Status.nontrouve ? Colors.red : Colors.white,
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    article.product_name == "" ? "No name" : article.product_name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    article.brands == "" ? "No brand" : article.brands,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          InkWell(
              onTap: () => {
                Provider.of<ArticleUsage>(context, listen: false).articleNonTrouve(article.id),
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Article non trouvé en épicerie :(")))
              },
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 32,
              )
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () => {
                    Provider.of<ArticleUsage>(context, listen: false)
                        .articleAchete(article.id),
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Article acheté :)")))
                  },
            child: Icon(
              Icons.check,
              color: Colors.green,
              size: 32,
            )
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
