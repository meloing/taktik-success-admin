import '../../services/api_quiz.dart';
import 'package:flutter/material.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  @override
  State<AddQuizScreen> createState() => AddQuizScreenState();
}

class AddQuizScreenState extends State<AddQuizScreen> {
  String env = "Dev";
  bool launch = false;
  String subject = "";
  List quizLevels = [];
  String typeValue = "";
  String levelValue = '';
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController addController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController minusController = TextEditingController();
  TextEditingController secondController = TextEditingController();
  TextEditingController consigneController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController questionsController = TextEditingController();

  var types = ['', 'unlock', 'lock'];
  var levels = ['', 'cp1', 'cp2', 'ce1', 'ce2', 'cm1', 'cm2', '6eme', '5eme',
                '4eme', '3eme', 'seca', 'secc', '1erea', '1erec', '1ered',
                'tlea', 'tlec', 'tled', 'cafop', 'ena', 'infasbepc', 'infasbac'];
  var subjects = ['','all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st',
                  'cg', 'av', 'lm'];

  Future addQuiz() async{

    setState(() { launch = true; });
    String add = addController.text;
    String title = titleController.text;
    String minus = minusController.text;
    String consigne = consigneController.text;
    String subTitle = subTitleController.text;
    String questions = questionsController.text;
    int second = int.parse(secondController.text);
    String date = DateTime.now().toString().split(".")[0];
    var response = await QuizRequests().addQuiz(add, title, minus, second, consigne, subTitle,
                                 questions, date, subject, quizLevels, typeValue, env);

    modal(response);

    setState(() {
      launch = false;
      if(response) {
        quizLevels.clear();
        addController.text = "";
        titleController.text = "";
        minusController.text = "";
        secondController.text = "";
        dateController.text = date;
        consigneController.text = "";
        subTitleController.text = "";
        questionsController.text = "";
      }
    });
  }

  void modal(bool value){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text("Information"),
            content: Text(
                value ? "Ajout effectué avec succès" :
                "Erreur lors de l'ajout"
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("Fermer")
              )
            ]
        )
    );
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
                      "AJOUTER UN QUIZ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  Form(
                      key: _registerFormKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: dateController,
                                decoration: const InputDecoration(
                                    labelText: "Date dernier quiz",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                    labelText: "Titre",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: subTitleController,
                                decoration: const InputDecoration(
                                    labelText: "Sous titre",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: consigneController,
                                decoration: const InputDecoration(
                                    labelText: "Consigne",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: addController,
                                decoration: const InputDecoration(
                                    labelText: "Plus",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: minusController,
                                decoration: const InputDecoration(
                                    labelText: "Minus",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: secondController,
                                decoration: const InputDecoration(
                                    labelText: "Seconde",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField(
                                value: typeValue,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Type",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: types.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    typeValue = newValue!;
                                  });
                                },
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Ce champ est obligatoire';
                                  }
                                  return null;
                                }
                            ),
                            const SizedBox(height: 15),
                            Row(
                                children: quizLevels.map(
                                        (e) => TextButton(
                                        onPressed: (){
                                          setState(() {
                                            quizLevels.remove(e);
                                          });
                                        },
                                        child: Text(e)
                                    )
                                ).toList()
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField(
                                value: levelValue,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Niveau",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: levels.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    levelValue = newValue!;
                                    quizLevels.add(levelValue);
                                  });
                                }
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField(
                                value: subject,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Matières",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: subjects.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    subject = newValue!;
                                  });
                                }
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                maxLines: 20,
                                controller: questionsController,
                                decoration: const InputDecoration(
                                    labelText: "Questions",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            )
                          ]
                      )
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                  )
                              )
                          ),
                          onPressed: (){
                            if(_registerFormKey.currentState!.validate()){
                              !launch ? addQuiz() : null;
                            }
                          },
                          child: !launch ?
                          const Text(
                            "Enregister",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ) :
                          const CircularProgressIndicator(
                              color: Colors.white
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}