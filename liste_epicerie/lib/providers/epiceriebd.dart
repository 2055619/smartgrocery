
import 'dart:async';
import 'package:liste_epicerie/models/article.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class EpicerieBD {

  late final _dbPath;
  late final _dbName;
  late final Future<Database> _database;

  get database {
    return _database;
  }

  EpicerieBD() {
    _database = _init();
  }

  static createDatabase() async {
    final dbpath = await getDatabasesPath();
    final dbName = path.join(dbpath, "epicerie.db");

    await deleteDatabase(dbName);

    await openDatabase(
      dbName,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE article ("
                "_id TEXT PRIMARY KEY, "
                "product_name TEXT, "
                "allergens TEXT, "
                "brands TEXT, "
                "categories TEXT, "
                "creator TEXT, "
                "image_url TEXT, "
                "nutriscore_grade TEXT, "
                "url TEXT, "
                "status TEXT, "
                "dateAchat TEXT "
                ")"
        );
      },
    );
  }

  Future<Database> getDatabases() async {
    final _db = await _database;
    if(_db.isOpen) return _db;

    return await openDatabase(_dbName);
  }

  Future<Database> _init() async {
    _dbPath = await getDatabasesPath();
    _dbName = path.join(_dbPath, "epicerie.db");

    return await openDatabase(_dbName);
  }

  Future<List<Article>> loadArticles() async {
    List<Article> articles = [];

    final db = await getDatabases();

    final result = await db.query("article", columns: ['*']);

    for(int i=0; i<result.length; i++){
      articles.add(Article.fromMap(result[i]));
    }

    return articles;
  }

  Future<void> addArticle(Article article) async {
    final db = await _database;

    final result = await db.query("article", columns: ['*'], where: "_id = ?", whereArgs: [article.id]);

    if(result.isNotEmpty) return;
    db.insert("article", article.toMap());
  }

  Future<void> deleteArticle(id) async {
    final db = await _database;

    db.delete("article", where: "_id = ?", whereArgs: [id]);
  }

  Future<void> setArticleAchete(String idArticle) async {
    final db = await _database;

    final result = await db.query("article", columns: ['*'], where: "_id = ?", whereArgs: [idArticle]);

    if(result.isEmpty) return;
    db.update("article", {'status': Status.achete.toString(), 'dateAchat': DateTime.now().toString()}, where: "_id = ?", whereArgs: [idArticle]);
  }

  Future<void> saveListeEpicerie(List<Article> articles) async {
    final db = await _database;

    final result = await db.query("article", columns: ['*']);

    if(result.isNotEmpty){
      await db.delete("article");
    }

    for(int i=0; i<articles.length; i++){
      db.insert("article",articles[i].toMap());
    }
  }

  setEpicerieAchete() async {
    final db = await _database;

    db.delete("article");
  }
}

