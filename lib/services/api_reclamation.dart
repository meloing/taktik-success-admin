import 'package:cloud_firestore/cloud_firestore.dart';

class ReclamationRequests {
  String env = "Prod";
  CollectionReference courses = FirebaseFirestore.instance.collection('coursesProd');
  CollectionReference users = FirebaseFirestore.instance.collection('usersProd');
  CollectionReference products = FirebaseFirestore.instance.collection('productsProd');
  CollectionReference commands = FirebaseFirestore.instance.collection('commandsProd');

  Future addCourse(List level, String title, String subject, String description,
      String date, String exercises, String type, String env,
      [String docId=""]) async {
    courses = FirebaseFirestore.instance.collection('courses$env');
    Map<String, dynamic> value = {
      "type": type,
      "date" : date,
      "title" : title,
      "level" : level,
      "subject" : subject,
      "exercises" : exercises,
      "description" : description
    };

    if(env == "Prod"){
      return courses
          .doc(docId)
          .set(value)
          .then((value) => true)
          .catchError((error) => false);
    }
    else{
      return courses
          .add(value)
          .then((value) => true)
          .catchError((error) => false);
    }
  }

  Future updateCourse(List level, String title, String subject, String description,
      String date, String exercises, String type, String courseId) async {
    return courses
        .doc(courseId)
        .update({
      "env": "Dev",
      "type": type,
      "date" : date,
      "title" : title,
      "level" : level,
      "subject" : subject,
      "exercises" : exercises,
      "description" : description
    })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future getCourses() async{
    QuerySnapshot querySnapshot = await courses.get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['courseId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future addUser(data) async {
    return users
        .doc(data["uid"])
        .set(data)
        .then((value) => true)
        .catchError((error) => false);
  }

  Future deleteUser(docId) async{
    await users.doc(docId).delete();
  }

  Future getUsers() async{
    QuerySnapshot querySnapshot = await users.get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['docId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future getUserByEmail(String email) async{
    QuerySnapshot querySnapshot = await users
        .where("email", isEqualTo: email)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['uid'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future getDocument(String name) async{
    QuerySnapshot querySnapshot = await products
        .where("name", isEqualTo: name)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['uid'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future updateUserPremium(String uid, String date) async {
    return users
        .doc(uid)
        .update({
          "premiumFinish" : date
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future addBuyDoc(String account, String transDate, String docId, String formula,
      String transId, String expireDate, String operatorId, String paymentMethod,
      String uid) async {

    Map<String, dynamic> value = {
      "uid": uid,
      "docId" : docId,
      "formula" : formula,
      "cpm_amount" : account,
      "cpm_currency" : "XOF",
      "cpm_site_id" : "928463",
      "cpm_trans_id" : transId,
      "expire_date" : expireDate,
      "operator_id" : operatorId,
      "cpm_trans_date" : transDate,
      "payment_method" : paymentMethod,
      "command_type": "command_document"
    };

    return commands
        .add(value)
        .then((value) => true)
        .catchError((error) => false);
  }
}