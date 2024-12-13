import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../../services/api_articles.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class AddArticleScreen extends StatefulWidget {
  const AddArticleScreen({super.key});

  @override
  State<AddArticleScreen> createState() => AddArticleScreenState();
}

class AddArticleScreenState extends State<AddArticleScreen> {
  List add = [];
  String env = "Dev";
  bool launch = false;
  String visualizeText = "";
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController pictureController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future addArticle() async{

    setState(() { launch = true; });
    String title = titleController.text;
    String picture = pictureController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response = await ArticlesRequests().addArticle(title, description,
        picture, date, env);

    if(response != "error"){
      add.add(
          {
            "env": "Dev",
            "date": date,
            "picture": picture,
            "articleId": response,
            "title": titleController.text,
            "description": descriptionController.text
          }
      );
      setState(() {
        titleController.text = "";
        dateController.text = date;
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
                const Text("Gestion des articles")
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
                      "AJOUTER UN ARTICLE",
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
                                    labelText: "Date dernier article",
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
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                      controller: pictureController,
                                      decoration: const InputDecoration(
                                          labelText: "Image",
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
                                  )
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                    onPressed: ()async{
                                      String fileUrl = await Utilities().loadImages();
                                      if(fileUrl.isNotEmpty){
                                        setState(() {
                                          pictureController.text = fileUrl;
                                        });
                                      }
                                    },
                                    child: const Text("Ajouter une image")
                                )
                              ]
                            ),
                            const SizedBox(height: 15),
                            Utilities().markdownWidget(markd),
                            const SizedBox(height: 20),
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
                                      "Visualiser",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              )
                          )
                      ),
                      const SizedBox(width: 10),
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
                                      !launch ? addArticle() : null;
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