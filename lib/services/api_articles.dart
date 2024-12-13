import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesRequests {
  CollectionReference articles = FirebaseFirestore.instance.collection('articlesDev');

  Future addArticle(String title, String description, String picture,
                    String date, String env, [String docId=""]) async {
    articles = FirebaseFirestore.instance.collection('articles$env');
    Map<String, dynamic> value = {
      "date" : date,
      "title": title,
      "picture" : picture,
      "description" : description
    };

    if(env == "Prod"){
      return articles
          .doc(docId)
          .set(value)
          .then((value) => true)
          .catchError((error) => false);
    }
    else{
      return articles
          .add(value)
          .then((value) => value.id)
          .catchError((error) => "error");
    }
  }

  Future updateArticle(String title, String description, String date,
                       String articleId, String picture) async {
    return articles
           .doc(articleId)
           .update({
            "date" : date,
            "title": title,
            "picture": picture,
            "description" : description,
           })
           .then((value) => true)
           .catchError((error) => false);
  }

  Future getArticles() async{
    QuerySnapshot querySnapshot = await articles.get();
    final allData = querySnapshot.docs.map(
            (doc){
              Map value = doc.data() as Map;
              value['articleId'] = doc.id;
              return value;
            }
    ).toList();

    return allData;
  }

  Future getCommands() async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('commandsProd').get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['command_type'] = "command_premium";
          /*
          value['send'] = "yes";
          value['command_type'] = "command_corrector";

          value['command_type'] = "command_document";
          value['command_type'] = "command_premium";*/
          return value;
        }
    ).toList();

    /*
    for(Map data in allData){
      Map<String, dynamic> newData = data as Map<String, dynamic>;
      await FirebaseFirestore.instance.collection('commandsProd')
            .add(newData)
            .then((value) => print(value.id))
            .catchError((error) => print("error"));
    }*/
    return allData;
  }

  Future updateStatus(String productId, String env) async {
    return articles
           .doc(productId)
           .update({
              "env" : env
           })
           .then((value) => true)
           .catchError((error) => false);
  }
}