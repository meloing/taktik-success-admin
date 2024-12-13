import 'package:cloud_firestore/cloud_firestore.dart';

class CourseRequests {
  CollectionReference courses = FirebaseFirestore.instance.collection('coursesDev');
  CollectionReference users = FirebaseFirestore.instance.collection('usersProd');

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

  Future getSpecificCourses(String level, String subject) async{
    QuerySnapshot querySnapshot = await courses
        .where("level", arrayContains: level)
        .where("subject", isEqualTo: subject)
        .orderBy("date", descending: true)
        .get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['courseId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future updateStatus(String productId, String env) async {
    return courses
        .doc(productId)
        .update({
          "env" : env
        })
        .then((value) => true)
        .catchError((error) => false);
  }
}