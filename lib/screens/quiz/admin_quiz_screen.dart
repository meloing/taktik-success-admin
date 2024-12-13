import 'add_quiz_screen.dart';
import '../../services/api_quiz.dart';
import 'package:flutter/material.dart';
import 'package:totale_reussite_admin/screens/quiz/update_quiz_screen.dart';

class AdminQuizScreen extends StatefulWidget {
  const AdminQuizScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<AdminQuizScreen> createState() => AdminQuizScreenState();
}

class AdminQuizScreenState extends State<AdminQuizScreen> {
  List quiz = [];
  String uid = "";
  String env = "Prod";

  Future addQuizToProd(index) async{
    Map qui = quiz[index];

    String add = qui["quizzAdd"];
    String quizId = qui["quizId"];
    String date = qui["quizzDate"];
    String type = qui["quizzType"];
    List level = qui["quizzLevel"];
    String title = qui["quizzTitle"];
    String minus = qui["quizzMinus"];
    String subject = qui["quizzSubject"];
    String consigne = qui["quizzConsigne"];
    String subTitle = qui["quizzSubTitle"];
    String questions = qui["quizzQuestions"];
    String second = qui["quizzSecond"].toString();

    await QuizRequests().addQuiz(add, title, minus, second, consigne, subTitle,
                                 questions, date, subject, level, type, env, quizId);

    await QuizRequests().updateStatus(quizId, "Prod");

    setState(() {
      quiz[index]["env"] = "Prod";
    });
  }

  Future getQuiz() async{
    List values = await QuizRequests().getQuiz();
    setState(() {
      quiz.clear();
      quiz.addAll(values);
    });
  }

  void modal(index){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention !!!"),
          content: const Text(
              "Attention le QUIZ sera disponible pour tous."
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("Annuler")
            ),
            TextButton(
                onPressed: (){
                  addQuizToProd(index);
                  Navigator.of(context).pop();
                },
                child: const Text("Valider")
            )
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getQuiz();
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
                      "GESTION DES QUIZ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AddQuizScreen()
                            )
                        );
                      },
                      child: const Text("Ajouter un quiz")
                  ),
                  Column(
                      children: Iterable<int>.generate(quiz.length).toList().map(
                              (index){
                                Map e = quiz[index];
                                return Column(
                                    children: [
                                      TextButton(
                                          onPressed: (){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => UpdateQuizScreen(
                                                        quiz: e
                                                    )
                                                )
                                            );
                                          },
                                          child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        e['quizzTitle'].toLowerCase(),
                                                        textAlign: TextAlign.justify,
                                                        style:  const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.black
                                                        )
                                                    )
                                                ),
                                                uid == 'archetechnology1011@gmail.com' ?
                                                IconButton(
                                                    onPressed: (){
                                                      modal(index);
                                                    },
                                                    icon: const Icon(
                                                        Icons.add_rounded
                                                    )
                                                ) :
                                                const SizedBox(),
                                                Icon(
                                                    Icons.circle,
                                                    color: e["env"] == null ? Colors.red :
                                                    e["env"] == "Prod" ? Colors.green : Colors.red
                                                )
                                              ]
                                          )
                                      ),
                                      const Divider()
                                    ]
                                );
                              }
                      ).toList()
                  )
                ]
            )
        )
    );
  }
}