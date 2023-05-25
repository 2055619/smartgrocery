import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:liste_epicerie/models/article.dart';

class DetailArticle extends StatelessWidget {
  DetailArticle(this.article, {Key? key}) : super(key: key);
  final Article article;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(article.product_name),
      content: SizedBox(
        height: 500,
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.image_url,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            article.brands == ""
                ? const Text("No brand")
                : Text('Brands: ${article.brands}'),
            article.categories == ""
                ? const Text("No categories")
                : Text('Categories: ${article.categories}'),
            article.allergens == ""
                ? const Text("No allergens")
                : Text('Allergens: ${article.allergens}'),
            article.creator == ""
                ? const Text("No creator")
                : Text('Creator: ${article.creator}'),
            article.nutriscore_grade == ""
                ? const Text("No nutriscore grade")
                : Text('Nutriscore Grade: ${article.nutriscore_grade}'),
            SizedBox(height: 16),
            article.url != "" ?
            ElevatedButton(
              onPressed: () async {
                launch(article.url);
              },
              child: Text('View on OpenFoodFacts'),
            ) :
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
