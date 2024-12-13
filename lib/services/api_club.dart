import 'package:cloud_firestore/cloud_firestore.dart';

class ClubRequests {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference clubs = FirebaseFirestore.instance.collection('clubs');

  Future getClubs() async{
    QuerySnapshot querySnapshot = await clubs.get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['clubId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future addClub(String name, String description, String icon, String date) async {
    return clubs
        .add({
          "clubDate" : date,
          "clubName" : name,
          "clubIcon" : icon,
          "clubDescription" : description
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future updateClub(String name, String description, String icon,
                    String date, String clubId) async {
    return clubs
        .doc(clubId)
        .update({
          "clubDate" : date,
          "clubName" : name,
          "clubIcon" : icon,
          "clubDescription" : description
        })
        .then((value) => true)
        .catchError((error) => true);
  }
}