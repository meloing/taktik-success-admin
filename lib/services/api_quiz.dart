import 'package:cloud_firestore/cloud_firestore.dart';

class QuizRequests {
  CollectionReference quiz = FirebaseFirestore.instance.collection('quizzDev');

  Future getQuiz() async{
    QuerySnapshot querySnapshot = await quiz.orderBy("quizzDate", descending: true).get();
    final allData = querySnapshot.docs.map(
            (doc){
          Map value = doc.data() as Map;
          value['quizId'] = doc.id;
          return value;
        }
    ).toList();

    return allData;
  }

  Future addQuiz(add, title, minus, second, consigne, subTitle, questions,
                 date, subject, level, type, String env, [String quizId=""]){

    quiz = FirebaseFirestore.instance.collection('quizz$env');

    Map<String, dynamic> value = {
      "quizzAdd" : add,
      "quizzDate": date,
      "quizzType": type,
      "quizzLevel": level,
      "quizzTitle" : title,
      "quizzMinus" : minus,
      "quizzSecond": second,
      "quizzSubject": subject,
      "quizzSubTitle": subTitle,
      "quizzConsigne" : consigne,
      "quizzQuestions": questions
    };

    if(env == "Prod"){
      return quiz
          .doc(quizId)
          .set(value)
          .then((value) => true)
          .catchError((error) => false);
    }
    else{
      return quiz
          .add(value)
          .then((value) => true)
          .catchError((error) => false);
    }
  }

  Future updateQuiz(add, title, minus, second, consigne, subTitle, questions,
                    date, subject, level, type, quizId){
    return quiz
        .doc(quizId)
        .update({
          "quizzAdd" : add,
          "quizzDate": date,
          "quizzType": type,
          "quizzLevel": level,
          "quizzTitle" : title,
          "quizzMinus" : minus,
          "quizzSecond": second,
          "quizzSubject": subject,
          "quizzSubTitle": subTitle,
          "quizzConsigne" : consigne,
          "quizzQuestions": questions
        })
        .then((value) => true)
        .catchError((error) => false);
  }

  Future updateStatus(String quizId, String env) async {
    return quiz
        .doc(quizId)
        .update({
          "env" : env
        })
        .then((value) => true)
        .catchError((error) => false);
  }
}