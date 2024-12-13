import 'add_articles_screen.dart';
import 'package:flutter/material.dart';
import '../../services/api_articles.dart';
import 'package:totale_reussite_admin/screens/articles/update_article_screen.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<ArticleScreen> createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  String uid = "";
  List articles = [];
  String env = "Prod";

  Future addArticleToProd(Map article) async{
    String date = article["date"];
    String title = article["title"];
    String picture = article["picture"];
    String docId = article["articleId"];
    String description = article["description"];

    await ArticlesRequests().addArticle(title, description, picture,
                                        date, env, docId);
    await ArticlesRequests().updateStatus(docId, env);
  }

  Future getArticles() async{
    List values = await ArticlesRequests().getArticles();
    setState(() {
      articles.addAll(values);
    });
  }

  void modal(Map e){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention !!!"),
          content: const Text("Attention cet article sera disponible pour tous."),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("Annuler")
            ),
            TextButton(
                onPressed: (){
                  addArticleToProd(e);
                  Navigator.of(context).pop();
                },
                child: const Text("Valider")
            )
          ]
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getArticles();
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Text("Admin")
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                      "GESTION DES ARTICLES",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  TextButton(
                      onPressed: ()async{
                        var value = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AddArticleScreen()
                            )
                        );

                        if(value != null && value.isNotEmpty){
                          setState(() {
                            articles.addAll(value);
                          });
                        }
                      },
                      child: const Text("Ajouter un article")
                  ),
                  Column(
                      children: Iterable.generate(articles.length).toList().map(
                              (index) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                          onPressed: ()async{
                                            var value = await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => UpdateArticleScreen(
                                                        article: articles[index]
                                                    )
                                                )
                                            );

                                            if(value != null){
                                              setState(() {
                                                articles[index] = value;
                                              });
                                            }
                                          },
                                          child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        articles[index]['title'].toLowerCase(),
                                                        textAlign: TextAlign.justify,
                                                        style:  const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.black
                                                        )
                                                    )
                                                ),
                                                const SizedBox(width: 10),
                                                const Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    color: Colors.grey
                                                )
                                              ]
                                          )
                                      )
                                    ),
                                    uid == 'archetechnology1011@gmail.com' ?
                                    IconButton(
                                        onPressed: (){
                                          modal(articles[index]);
                                        },
                                        icon: const Icon(
                                            Icons.add_rounded
                                        )
                                    ) :
                                    const SizedBox(),
                                    Icon(
                                        Icons.circle,
                                        color: articles[index]["env"] == null ? Colors.red :
                                        articles[index]["env"] == "Prod" ? Colors.green : Colors.red
                                    )
                                  ]
                                ),
                                const Divider()
                              ]
                          )
                      ).toList()
                  )
                ]
            )
        )
    );
  }
}