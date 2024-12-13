import 'package:cloud_firestore/cloud_firestore.dart';

class CompetitionRequests {
  CollectionReference competition = FirebaseFirestore.instance.collection('competitionDev');

  Future addCompetition(String title, String description, String link, String date,
                        String contacts, String picture, String country, String env,
                        [String docId=""]) async {
    competition = FirebaseFirestore.instance.collection('competition$env');

    Map<String, dynamic> value = {
      "date" : date,
      "link" : link,
      "name" : title,
      "picture": picture,
      "country": country,
      "contacts": contacts,
      "description" : description
    };

    if(env == "Prod"){
      return competition
          .doc(docId)
          .set(value)
          .then((value) => true)
          .catchError((error) => false);
    }
    else{
      return competition
          .add(value)
          .then((value) => value.id)
          .catchError((error) => "error");
    }
  }

  Future updateCompetition(String title, String description, String link, String date,
                           String contacts, String picture, String country,
                           String competitionId) async {
    return competition
        .doc(competitionId)
        .update({
          "date" : date,
          "link" : link,
          "name" : title,
          "picture": picture,
          "country": country,
          "contacts": contacts,
          "description" : description
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future getCompetition() async{
    QuerySnapshot querySnapshot = await competition.get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['competitionId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future updateStatus(String productId, String env) async {
    return competition
          .doc(productId)
          .update({
            "env" : env
          })
          .then((value) => true)
          .catchError((error) => false);
  }
}