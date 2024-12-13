import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../../services/api_articles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateArticleScreen extends StatefulWidget {
  const UpdateArticleScreen({
    super.key,
    required this.article
  });

  final Map article;

  @override
  State<UpdateArticleScreen> createState() => UpdateArticleScreenState();
}

class UpdateArticleScreenState extends State<UpdateArticleScreen> {
  Map article = {};
  bool launch = false;
  String visualizeText = "";
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController pictureController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future updateArticle() async{

    setState(() { launch = true; });

    String title = titleController.text;
    String picture = pictureController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response = await ArticlesRequests().updateArticle(title, description,
        date, article["articleId"], picture);

    modal(response);

    if(response){
      setState(() {
        dateController.text = date;
      });

      article["date"] = date;
      article["title"] = title;
      article["picture"] = picture;
      article["description"] = description;
    }

    setState(() { launch = false; });
  }

  Future<void> loadImages(String part) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: ["png", "jpg", "jpeg"]
    );

    if(result?.files.first != null){

      var fileBytes = result?.files.first.bytes;
      var fileName = DateTime.now().toString().replaceAll(".", "")
          .replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "");

      String fileUrl = await (
          await FirebaseStorage.instance.ref().child('ressources/$fileName')
              .putData(fileBytes!)
              .whenComplete(() => null)).ref.getDownloadURL();

      fileUrl = Utilities().changeUrl(fileUrl);

      setState(() {
        if(part == "article"){
          descriptionController.text = "${descriptionController.text}\n||\n[img]$fileUrl";
        }
        else{
          pictureController.text = fileUrl;
        }
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

  void loadArticle(){
    setState(() {
      dateController.text = article["date"];
      titleController.text = article["title"];
      pictureController.text = article["picture"];
      descriptionController.text = Utilities().changeInMark(article["description"]);
    });
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

  @override
  void initState() {
    super.initState();
    article = widget.article;
    loadArticle();
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
                        Navigator.pop(context, article);
                      }
                  ),
                  const SizedBox(width: 15),
                  const Text("Gestion des modifications d'articles")
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
                      "MISE A JOUR UN ARTICLE",
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
                            const SizedBox(height: 15),
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
                                  !launch ? updateArticle() : null;
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