import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../../services/api_methods.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class UpdateMethodScreen extends StatefulWidget {
  const UpdateMethodScreen({
    super.key,
    required this.method
  });

  final Map method;

  @override
  State<UpdateMethodScreen> createState() => UpdateMethodScreenState();
}

class UpdateMethodScreenState extends State<UpdateMethodScreen> {
  Map method = {};
  bool launch = false;
  String typeValue = "";
  String subjectValue = "";
  String visualizeText = "";
  var types = ["", "lock", "unlock"];
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var subjects = ['all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st'];

  Future updateMethods() async{

    setState(() { launch = true; });

    String title = titleController.text;
    String subtitle = subtitleController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response = await MethodsRequests().updateMethod(title, description,
        subtitle, date, subjectValue, typeValue, method["methodId"]);

    modal(response);

    if(response){
      setState(() {
        dateController.text = date;
      });
      method["date"] = date;
      method["title"] = title;
      method["subtitle"] = subtitle;
      method["subject"] = subjectValue;
      method["description"] = description;
    }

    setState(() { launch = false; });
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
      var fileName = DateTime.now().toString().replaceAll(".", "").replaceAll(" ", "");

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

  void loadMethod(){
    setState(() {
      typeValue = method["type"];
      subjectValue = method["subject"];
      dateController.text = method["date"];
      titleController.text = method["title"];
      subtitleController.text = method["subtitle"];
      descriptionController.text = method["description"];
      // descriptionController.text = Utilities().changeInMark(method["description"]);
    });
  }

  @override
  void initState() {
    super.initState();
    method = widget.method;
    loadMethod();
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
                        Navigator.pop(context, method);
                      }
                  ),
                  const SizedBox(width: 15),
                  const Text("Gestion des modifications de point methode")
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
                      "MISE A JOUR D'UNE METHODE",
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
                                  loadImages();
                                },
                                child: const Text("Ajouter une image")
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                                height: 500,
                                child: Markdown(
                                    imageBuilder: (uri, title, alt){
                                      return Image.network(
                                        Utilities().changeUrl(uri.toString())
                                      );
                                    },
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
                                    !launch ? updateMethods() : null;
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