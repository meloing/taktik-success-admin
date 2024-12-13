import 'package:flutter/material.dart';
import '../../services/api_competition.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:totale_reussite_admin/services/utilities.dart';

class UpdateCompetitionScreen extends StatefulWidget {
  const UpdateCompetitionScreen({
    super.key,
    required this.competition
  });

  final Map competition;

  @override
  State<UpdateCompetitionScreen> createState() => UpdateCompetitionScreenState();
}

class UpdateCompetitionScreenState extends State<UpdateCompetitionScreen> {
  bool launch = false;
  Map competition = {};
  String visualizeText = "";
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController idController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pictureController = TextEditingController();
  TextEditingController contactsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future updateCompetition() async{

    setState(() { launch = true; });

    String link = linkController.text;
    String title = nameController.text;
    String picture = pictureController.text;
    String country = countryController.text;
    String contacts = contactsController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response = await CompetitionRequests().updateCompetition(title, description,
        link, date, contacts, picture, country, competition["competitionId"]);

    modal(response);

    if(response){
      setState(() {
        dateController.text = date;
      });

      competition["date"] = date;
      competition["link"] = link;
      competition["name"] = title;
      competition["picture"] = picture;
      competition["country"] = country;
      competition["contacts"] = contacts;
      competition["description"] = description;
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
        if(part == "competition"){
          descriptionController.text = "${descriptionController.text}\n||\n[img]$fileUrl";
        }
        else{
          pictureController.text = fileUrl;
        }
      });
    }
  }

  void loadCompetition(){
    setState(() {
      dateController.text = competition["date"];
      nameController.text = competition["name"];
      linkController.text = competition["link"];
      pictureController.text = competition["picture"];
      countryController.text = competition["country"];
      idController.text = competition["competitionId"];
      contactsController.text = competition["contacts"];
      descriptionController.text = Utilities().changeInMark(competition["description"]);
    });
  }

  void modal(bool value){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text("Information"),
            content: Text(
                value ? "Mise à jour effectuée avec succès" :
                "Erreur lors de la mise à jour"
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
    competition = widget.competition;
    loadCompetition();
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
                        Navigator.pop(context, competition);
                      }
                  ),
                  const SizedBox(width: 15),
                  const Text("Gestion des modifications de concours")
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
                      "MISE A JOUR UN CONCOURS",
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
                                controller: idController,
                                decoration: const InputDecoration(
                                    labelText: "Id article",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: nameController,
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
                                controller: contactsController,
                                decoration: const InputDecoration(
                                    labelText: "Contacts",
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
                                      onPressed: (){
                                        loadImages("picture");
                                      },
                                      child: const Text("Ajouter une image")
                                  )
                                ]
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: linkController,
                                decoration: const InputDecoration(
                                    labelText: "Lien",
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
                                controller: countryController,
                                decoration: const InputDecoration(
                                    labelText: "Pays",
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
                            const SizedBox(height: 10),
                            TextButton(
                                onPressed: (){
                                  loadImages("competition");
                                },
                                child: const Text("Ajouter une image")
                            )
                          ]
                      )
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 500,
                      child: Markdown(
                          data: visualizeText
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
                                    "Visualiser le concours",
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
                                    !launch ? updateCompetition() : null;
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