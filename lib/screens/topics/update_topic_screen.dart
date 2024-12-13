import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../../services/api_topics.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class UpdateTopicScreen extends StatefulWidget {
  const UpdateTopicScreen({
    super.key,
    required this.topic
  });

  final Map topic;

  @override
  State<UpdateTopicScreen> createState() => UpdateTopicScreenState();
}

class UpdateTopicScreenState extends State<UpdateTopicScreen> {
  Map topic = {};
  int topicIndex = 0;
  bool launch = false;

  List topicLevels = [];
  String typeValue = "";
  String levelValue = "";
  String subjectValue = "";
  String visualizeText = "";
  String fileTypeValue = "";

  List topicIndexLists = [];

  var fileTypes = ['', 'picture_text|pdf', 'pdf|picture_text',
                   'pdf|pdf', 'picture_text|picture_text'];
  var types = ['', 'unlock', 'correctionLock', 'lock'];
  var levels = ['', 'cp1', 'cp2', 'ce1', 'ce2', 'cm1', 'cm2', '6eme', '5eme',
                '4eme', '3eme', 'seca', 'secc', '1erea', '1erec', '1ered',
                'tlea', 'tlec', 'tled', 'cafop', 'ena', 'infasbepc', 'infasbac'];
  var subjects = ['','all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st',
                  'cg', 'av', 'lm'];

  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController exerciseController = TextEditingController();
  TextEditingController correctionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future updateTopic() async{

    setState(() { launch = true; });

    String title = nameController.text;
    String exercise = exerciseController.text;
    String correction = correctionController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response = await TopicsRequests().updateTopic(title, description, subjectValue,
        date, topicLevels, exercise, correction, typeValue, fileTypeValue,
        topicIndex, topic["topicId"]);

    modal(response);

    setState(() {
      launch = false;
      dateController.text = date;
    });
  }

  Future<void> loadImages(String part) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowCompression: true,
        allowedExtensions: part == "pdfFile" ? ["pdf"] : ["png", "jpg", "jpeg"]
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
        if(part == "pdfFile"){
          exerciseController.text = fileUrl;
        }
        else{
          exerciseController.text = "${exerciseController.text}\n||\n[img]$fileUrl";
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
                value ? "Mise à jour effectué avec succès" :
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

  void markdExo (String element)async{
    if(element == "![Image](http://url/a.png)"){
      String fileUrl = await Utilities().loadImages();
      if(fileUrl.isNotEmpty){
        setState(() {
          exerciseController.text = "${exerciseController.text}\n![Image]($fileUrl)";
        });
      }
    }
    else{
      setState(() {
        exerciseController.text = "${exerciseController.text} $element";
      });
    }
  }

  void markdCor (String element)async{
    if(element == "![Image](http://url/a.png)"){
      String fileUrl = await Utilities().loadImages();
      if(fileUrl.isNotEmpty){
        setState(() {
          correctionController.text = "${correctionController.text}\n![Image]($fileUrl)";
        });
      }
    }
    else{
      setState(() {
        correctionController.text = "${correctionController.text} $element";
      });
    }
  }

  void loadTopic(){
    setState(() {
      typeValue = topic["type"];
      topicLevels = topic["level"];
      subjectValue = topic["subject"];
      topicIndex = topic["index"] ?? 0;
      dateController.text = topic["date"];
      nameController.text = topic["title"];
      exerciseController.text = Utilities().changeInMark(topic["exercise"]);
      correctionController.text = Utilities().changeInMark(topic["correction"]);
      descriptionController.text = topic["description"];

      if(topic.containsKey("fileType")){
        fileTypeValue = topic["fileType"];
      }
      else{
        fileTypeValue = "picture_text|picture_text";
      }

      topicIndexLists.clear();

      if(Constants.topicDetails[topicLevels[0]]![subjectValue] != null){
        topicIndexLists = Constants.topicDetails[topicLevels[0]]![subjectValue].toList();
        topicIndexLists.insert(0, "");
      }

    });
  }

  @override
  void initState() {
    super.initState();
    topic = widget.topic;
    loadTopic();
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
                      "Mettre a jour un fichier",
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
                                    labelText: "Date",
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
                                )
                            ),
                            const SizedBox(height: 15),
                            Row(
                                children: topicLevels.map(
                                        (e) => TextButton(
                                        onPressed: (){
                                          setState(() {
                                            topicLevels.remove(e);
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
                                    topicLevels.add(levelValue);
                                  });
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
                                    topicIndexLists.clear();

                                    if(Constants.topicDetails[topicLevels[0]]![subjectValue] != null){
                                      topicIndexLists = Constants.topicDetails[levelValue]![subjectValue].toList();
                                      topicIndexLists.insert(0, "");
                                    }
                                  });
                                }
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField(
                                value: topicIndex,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Index du sujet",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: Iterable<int>.generate(topicIndexLists.length).toList().map((int index) {
                                  return DropdownMenuItem(
                                    value: index,
                                    child: Text(topicIndexLists[index]),
                                  );
                                }).toList(),
                                onChanged: (int? index) {
                                  setState(() {
                                    topicIndex = index!;
                                  });
                                },
                                /*
                                validator: (value){
                                  if(value == null){
                                    return 'Ce champ est obligatoire';
                                  }
                                  return null;
                                }

                                 */
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
                                }
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField(
                                value: fileTypeValue,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Type Sujet",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: fileTypes.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    fileTypeValue = newValue!;
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
                            TextFormField(
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                    labelText: "Description",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            Utilities().markdownWidget(markdExo),
                            const SizedBox(height: 15),
                            TextFormField(
                                maxLines: 20,
                                controller: exerciseController,
                                decoration: const InputDecoration(
                                    labelText: "Exercice",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 15),
                            Utilities().markdownWidget(markdCor),
                            const SizedBox(height: 15),
                            TextFormField(
                                maxLines: 20,
                                controller: correctionController,
                                decoration: const InputDecoration(
                                    labelText: "Correction",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                                onPressed: (){
                                  loadImages("pdfFile");
                                },
                                child: const Text("Ajouter le pdf")
                            ),
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
                                      visualizeText = exerciseController.text;
                                    });
                                  },
                                  child: const Text(
                                      "Visualiser exercice",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      )
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
                                      visualizeText = correctionController.text;
                                    });
                                  },
                                  child: const Text(
                                      "Visualiser correction",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      )
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
                                      !launch ? updateTopic() : null;
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