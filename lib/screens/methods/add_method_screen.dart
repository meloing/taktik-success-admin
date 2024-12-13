import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../../services/api_methods.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AddMethodScreen extends StatefulWidget {
  const AddMethodScreen({super.key});

  @override
  State<AddMethodScreen> createState() => AddMethodScreenState();
}

class AddMethodScreenState extends State<AddMethodScreen> {
  List add = [];
  String env = "Dev";
  bool launch = false;
  String typeValue = "";
  String visualizeText = "";
  String subjectValue = "fr";
  var types = ["", "lock", "unlock"];
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var subjects = ['all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st'];

  Future addMethod() async{

    setState(() { launch = true; });

    String title = titleController.text;
    String subtitle = subtitleController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response = await MethodsRequests().addMethod(title, description, subtitle,
        date, subjectValue, typeValue, env);

    if(response != "error"){
      add.add(
          {
            "env": "Dev",
            "date": date,
            "methodId": response,
            "subject": subjectValue,
            "title": titleController.text,
            "subtitle": subtitleController.text,
            "description": descriptionController.text
          }
      );

      setState(() {
        titleController.text = "";
        dateController.text = date;
        subtitleController.text = "";
        descriptionController.text = "";
      });
      modal(true);
    }
    else{
      modal(false);
    }

    setState(() { launch = false; });
  }

  void markd (String element)async{
    if(element == "![Image](http://url/a.png)"){
      String fileUrl = await Utilities().loadImages();
      if(fileUrl.isNotEmpty){
        setState(() {
          descriptionController.text = "${descriptionController.text}\n![Image]($fileUrl)";
        });
      }
    }
    else{
      setState(() {
        descriptionController.text = "${descriptionController.text} $element";
      });
    }
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
            automaticallyImplyLeading: false,
            title: Row(
                children: [
                  IconButton(
                      icon: const Icon(
                          Icons.arrow_back_rounded
                      ),
                      onPressed: (){
                        Navigator.pop(context, add);
                      }
                  ),
                  const SizedBox(width: 15),
                  const Text("Gestion des points methods")
                ]
            )
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                      "AJOUTER UNE METHODE",
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
                                    labelText: "Date dernier method",
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
                                ),
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Ce champ est obligatoire';
                                  }
                                  return null;
                                }
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: subtitleController,
                                decoration: const InputDecoration(
                                    labelText: "Sous titre",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                ),
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Ce champ est obligatoire';
                                  }
                                  return null;
                                }
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
                            DropdownButtonFormField(
                                value: subjectValue,
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
                                    subjectValue = newValue!;
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
                            Utilities().markdownWidget(markd),
                            const SizedBox(height: 25),
                            TextFormField(
                                maxLines: 20,
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                    labelText: "Description",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                ),
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Ce champ est obligatoire';
                                  }
                                  return null;
                                }
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                                height: 500,
                                child: Markdown(
                                  data: visualizeText
                                )
                            )
                          ]
                      )
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(
                                          Colors.grey
                                      ),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                          )
                                      )
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      visualizeText = descriptionController.text;
                                    });
                                  },
                                  child: const Text(
                                    "Visualiser cours",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              )
                          )
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: SizedBox(
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
                                    !launch ? addMethod() : null;
                                  }
                                },
                                child: !launch ?
                                const Text(
                                    "Enregister",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    )
                                ) :
                                const CircularProgressIndicator(
                                    color: Colors.white
                                )
                            )
                        )
                      )
                    ]
                  )
                ]
            )
        )
    );
  }
}