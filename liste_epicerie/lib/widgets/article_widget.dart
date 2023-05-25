
import 'package:flutter/material.dart';
import 'package:liste_epicerie/models/article.dart';
import 'package:liste_epicerie/widgets/detailarticle_widget.dart';

class ArticleWidget extends StatelessWidget {
  ArticleWidget({Key? key, required this.article}) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => DetailArticle(article),
        );
      },
      child: Card(
        color: article.status == Status.nontrouve ? Colors.red : article.status == Status.achete ? Colors.green : Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 16),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              backgroundImage: article.image_url == "" ? null : NetworkImage(article.image_url),
            ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      article.creator == "" ? "Creator unknown" : article.creator,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
