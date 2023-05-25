
enum Status {
  enAttente,
  achete,
  nontrouve,
}

class Article {
  final String _id;
  final String product_name;
  final String allergens;
  final String brands;
  final String categories;
  final String creator;
  final String image_url;
  final String nutriscore_grade;
  final String url;
  Status status;
  final String dateAchat;

  Article(this._id, this.product_name, this.allergens, this.brands, this.categories, this.creator, this.image_url, this.nutriscore_grade, this.url, this.status, this.dateAchat);

  static Article fromMap(Map<String, dynamic> map) {
    return Article(
      map['_id'] ?? '',
      map['product_name'] ?? '',
      map['allergens'] ?? '',
      map['brands'] ?? '',
      map['categories'] ?? '',
      map['creator'] ?? '',
      map['image_url'] ?? '',
      map['nutriscore_grade'] ?? '',
      map['url'] ?? '',
      map['status'] == null ? Status.enAttente : Status.values.firstWhere((element) => element.toString() == map['status']),
      map['dateAchat'] ?? '',
    );
  }

  String get id {
    return _id;
  }

  Map<String, Object?> toMap() {
    return {
      '_id': _id,
      'product_name': product_name,
      'allergens': allergens,
      'brands': brands,
      'categories': categories,
      'creator': creator,
      'image_url': image_url,
      'nutriscore_grade': nutriscore_grade,
      'url': url,
      'status': status.toString(),
      'dateAchat': dateAchat,
    };
  }
}
