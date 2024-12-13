import 'package:flutter/material.dart';
import '../../services/api_course.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:totale_reussite_admin/services/utilities.dart';

class UpdateCourseScreen extends StatefulWidget {
  const UpdateCourseScreen({
    super.key,
    required this.course
  });

  final Map course;

  @override
  State<UpdateCourseScreen> createState() => UpdateCourseScreenState();
}

class UpdateCourseScreenState extends State<UpdateCourseScreen> {
  late Map course;
  String path = "";
  List levels = [];
  bool launch = false;
  String typeValue = "";
  String visualizeText = "";
  String subjectValue = "all";
  String dropdownValue = 'cp1';
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController exercisesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var items = ['cp1', 'cp2', 'ce1', 'ce2', 'cm1', 'cm2', '6eme', '5eme',
               '4eme', '3eme', 'seca', 'secc', '1erea', '1erec', '1ered',
               'tlea', 'tlec', 'tled', 'cafop', 'ena', 'infasbepc', 'infasbac'];
  var subjects = ['all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st',
                  'cg', 'av', 'lm'];
  var types = ['lock', 'unlock'];

  void loadCourse(){
    setState(() {
      typeValue = course["type"];
      levels.addAll(course["level"]);
      subjectValue = course["subject"];
      dateController.text = course["date"];
      titleController.text = course["title"];
      exercisesController.text = Utilities().changeInMark(course["exercises"]);
      descriptionController.text = Utilities().changeInMark(course["description"]);
    });
  }

  Future updateCourse() async{

    setState(() { launch = true; });

    String title = titleController.text;
    String exercises = exercisesController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response  = await CourseRequests().updateCourse(levels, title, subjectValue,
        description, date, exercises, typeValue, course["courseId"]);

    modal(response);

    setState(() {
      launch = false;
      dateController.text = date;
    });
  }

  Future<void> loadImages() async{
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
        descriptionController.text = "${descriptionController.text}\n||\n[img]$fileUrl";
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

  void markdCor (String element)async{
    if(element == "![Image](http://url/a.png)"){
      String fileUrl = await Utilities().loadImages();
      if(fileUrl.isNotEmpty){
        setState(() {
          exercisesController.text = "${exercisesController.text}\n![Image]($fileUrl)";
        });
      }
    }
    else{
      setState(() {
        exercisesController.text = "${exercisesController.text} $element";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    course = widget.course;
    loadCourse();
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
                      "AJOUTER DES COURS",
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
                                controller: titleController,
                                decoration: const InputDecoration(
                                    labelText: "Titre du cours",
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
                            Row(
                              children: levels.map(
                                      (e) => TextButton(
                                          onPressed: (){
                                            setState(() {
                                              levels.remove(e);
                                            });
                                          },
                                          child: Text(e)
                                      )
                              ).toList()
                            ),
                            const SizedBox(height: 15),
                            DropdownButtonFormField(
                                value: dropdownValue,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Niveau",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                    levels.add(dropdownValue);
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
                                value: typeValue,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Type",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: types.map((String type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
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
                            Utilities().markdownWidget(markd),
                            const SizedBox(height: 15),
                            TextFormField(
                                maxLines: 20,
                                controller: descriptionController,
                                decoration: const InputDecoration(
                                    labelText: "Description du cours",
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
                            Utilities().markdownWidget(markdCor),
                            const SizedBox(height: 15),
                            TextFormField(
                                maxLines: 20,
                                controller: exercisesController,
                                decoration: const InputDecoration(
                                    labelText: "Exercices",
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
                                  loadImages();
                                },
                                child: const Text("Ajouter une image")
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
                                        visualizeText = exercisesController.text;
                                      });
                                    },
                                    child: const Text(
                                      "Visualiser exercice",
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
                                        !launch ? updateCourse() : null;
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
                        )
                      ]
                  )
                ]
            )
        )
    );
  }
}