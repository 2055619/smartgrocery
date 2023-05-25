
import 'package:flutter/material.dart';
import 'package:liste_epicerie/providers/articlelisteusage.dart';
import 'package:liste_epicerie/widgets/listearticle_widget.dart';
import 'package:provider/provider.dart';

class Historique extends StatefulWidget {
  const Historique({Key? key}) : super(key: key);

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {

  @override
  void initState() {
    super.initState();

    Provider.of<ArticleUsage>(context, listen: false).loadListesEpicerie();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ArticleUsage>(
      builder: (context, articleUsage, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await articleUsage.loadListesEpicerie();
          },
          child: ListView.builder(
            itemCount: articleUsage.epicerie.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(articleUsage.epicerie[index].date),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListeArticle(articleUsage.epicerie[index].id, articleUsage.idGroupe)));
                  },
              );
            },
          ),
        );
      }
    );
  }
}
