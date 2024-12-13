import 'package:cloud_firestore/cloud_firestore.dart';

class TopicsRequests {

  CollectionReference topics = FirebaseFirestore.instance.collection('topicsDev');

  Future getTopics(String level, String subject) async{
    QuerySnapshot querySnapshot = await topics
        .where("level", arrayContains: level)
        .where("subject", isEqualTo: subject)
        .orderBy("date", descending: true)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['topicId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future addTopic(String title, String description, String subject,
                  String date, List level, String exercise, String correction,
                  String type, String fileType, int index, String env, [String docId=""]) async {
    topics = FirebaseFirestore.instance.collection('topics$env');

    Map<String, dynamic> value = {
      "date" : date,
      "type" : type,
      "title" : title,
      "index" : index,
      "level" : level,
      "subject": subject,
      "exercise": exercise,
      "fileType": fileType,
      "correction": correction,
      "description" : description
    };

    if(env == "Prod"){
      return topics
             .doc(docId)
             .set(value)
             .then((value) => true)
             .catchError((error) => false);
    }
    else{
      return topics
             .add(value)
             .then((value) => true)
             .catchError((error) => false);
    }
  }

  Future updateTopic(String title, String description, String subject,
                     String date, List level, String exercise,
                     String correction, String type, String fileType, int index,
      String topicId) async {
    return topics
           .doc(topicId)
           .update({
              "env": "Dev",
              "date" : date,
              "type" : type,
              "title" : title,
              "index" : index,
              "level" : level,
              "subject": subject,
              "exercise": exercise,
              "fileType": fileType,
              "correction": correction,
              "description" : description
           })
           .then((value) => true)
           .catchError((error) => false);
  }

  Future updateStatus(String productId, String env) async {
    return topics
           .doc(productId)
           .update({
              "env" : env
           })
           .then((value) => true)
           .catchError((error) => false);
  }
}