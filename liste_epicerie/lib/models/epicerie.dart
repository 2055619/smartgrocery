import 'package:liste_epicerie/models/article.dart';

class Epicerie {
  final String _id;
  final List<Article> articles;
  late String date;

  Epicerie(this._id, this.articles,this.date);

  static Epicerie fromMap(Map<String, dynamic> map) {
    return Epicerie(
      map['_id'] ?? '',
      map['articles'] ? map['articles'].map((article) => Article.fromMap(article)).toList() : [],
      map['date'] ?? '',
    );
  }

  void ajoutArticle(Article article){
    articles.add(article);
  }

  String get id {
    return _id;
  }
}
