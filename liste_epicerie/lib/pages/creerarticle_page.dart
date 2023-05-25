
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liste_epicerie/pages/principale_page.dart';
import 'package:liste_epicerie/providers/articlesglobaux.dart';
import 'package:liste_epicerie/widgets/articleform_widget.dart';
import 'package:provider/provider.dart';

class CreerArticle extends StatefulWidget {
  CreerArticle({Key? key}) : super(key: key);

  static const routeName = "/creerarticle";

  @override
  State<CreerArticle> createState() => _CreerArticleState();
}

class _CreerArticleState extends State<CreerArticle> {

  Future<void> scanBarcodeNormal(ArticlesGlobaux articles) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted || barcodeScanRes == "-1") return;

    try{
      await articles.creeParScan(barcodeScanRes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur lors de la création de l'article : \n$e")
        ),
      );
      return;
    }
    Navigator.pop(context);
  }

  Future<void> ajoutArticle(
    String product_name,
    String allergens,
    String brands,
    String categories,
    String creator,
    String nutriscore_grade,
    String url,
    XFile image,
  ) async {
    final articles = context.read<ArticlesGlobaux>();

    await articles.ajoutArticle(
      product_name,
      allergens,
      brands,
      categories,
      creator,
      nutriscore_grade,
      url,
      image,
    );
    
    Navigator.of(context).pushNamed(Principale.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final articles = context.watch<ArticlesGlobaux>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un article"),
      ),
      body: ArticleForm(ajoutArticle),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          scanBarcodeNormal(articles);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Créer un article",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Scan",
          ),
        ],
      ),
    );
  }
}