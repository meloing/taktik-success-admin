import 'package:cloud_firestore/cloud_firestore.dart';

class MethodsRequests {
  CollectionReference methods = FirebaseFirestore.instance.collection('pointsMethodsDev');

  Future updateMethod(String title, String description, String subtitle,
                      String date, String subject, String type, String methodId) async {
    return methods
           .doc(methodId)
           .update({
            "env": "Dev",
            "date" : date,
            "type" : type,
            "title": title,
            "subject": subject,
            "subtitle" : subtitle,
            "description" : description,
          })
          .then((value) => true)
          .catchError((error) => false);
  }

  Future addMethod(String title, String description, String subtitle,
                   String date, String subject, String type, String env, [String docId=""]) async {
    methods = FirebaseFirestore.instance.collection('pointsMethods$env');
    Map<String, dynamic> value = {
      "date" : date,
      "type" : type,
      "title": title,
      "subject": subject,
      "subtitle" : subtitle,
      "description" : description
    };

    if(env == "Prod"){
      return methods
            .doc(docId)
            .set(value)
            .then((value) => true)
            .catchError((error) => false);
    }
    else{
      return methods
            .add(value)
            .then((value) => value.id)
            .catchError((error) => "error");
    }
  }

  Future updateStatus(String productId, String env) async {
    return methods
           .doc(productId)
           .update({
              "env" : env
            })
           .then((value) => true)
           .catchError((error) => false);
  }

  Future getMethods() async{
    QuerySnapshot querySnapshot = await methods.get();
    final allData = querySnapshot.docs.map(
            (doc){
                Map value = doc.data() as Map;
                value['methodId'] = doc.id;
                return value;
            }
    ).toList();

    return allData;
  }
}