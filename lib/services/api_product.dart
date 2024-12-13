import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRequests {
  CollectionReference products = FirebaseFirestore.instance.collection('productsDev');

  Future addProduct(String name, String description, String weekPrice,
                    String monthPrice, String yearPrice, String date,
                    String level, String subjects, String picture, String file,
                    String country, String levelAbr, String subjectAbr, String index,
                    String env, [String docId=""]) async {
    products = FirebaseFirestore.instance.collection('products$env');

    Map<String, dynamic> value = {
      "date" : date,
      "file" : file,
      "name" : name,
      "level" : level,
      "index" : index,
      "country" : country,
      "picture" : picture,
      "subjects": subjects,
      "levelAbr" : levelAbr,
      "weekPrice" : weekPrice,
      "yearPrice" : yearPrice,
      "subjectAbr" : subjectAbr,
      "monthPrice" : monthPrice,
      "description" : description
    };

    if(env == "Prod"){
      return products
            .doc(docId)
            .set(value)
            .then((value) => true)
            .catchError((error) => false);
    }
    else{
      return products
            .add(value)
            .then((value) => true)
            .catchError((error) => false);
    }
  }

  Future updateProduct(String name, String description, String weekPrice,
                       String monthPrice, String yearPrice, String date,
                       String level, String subjects, String picture, String file,
                       String country, String levelAbr, String subjectAbr,
                       String index, String productId) async {
    return products
        .doc(productId)
        .update({
          "date" : date,
          "file" : file,
          "name" : name,
          "level" : level,
          "index" : index,
          "country" : country,
          "picture" : picture,
          "subjects": subjects,
          "levelAbr" : levelAbr,
          "weekPrice" : weekPrice,
          "yearPrice" : yearPrice,
          "subjectAbr" : subjectAbr,
          "monthPrice" : monthPrice,
          "description" : description
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future updateStatus(String productId, String env) async {
    return products
        .doc(productId)
        .update({
          "env" : env
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future getProducts() async{
    QuerySnapshot querySnapshot = await products.get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['productId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }
}