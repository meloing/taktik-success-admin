import 'package:flutter/material.dart';
import '../../services/utilities.dart';
import '../../services/api_product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({
    super.key,
    required this.product
  });

  final Map product;

  @override
  State<UpdateProductScreen> createState() => UpdateProductScreenState();
}

class UpdateProductScreenState extends State<UpdateProductScreen> {
  Map product = {};
  bool launch = false;
  String picture = "";
  String visualizeText = "";
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController indexController = TextEditingController();
  TextEditingController pictureController = TextEditingController();
  TextEditingController pdfFileController = TextEditingController();
  TextEditingController subjectsController = TextEditingController();
  TextEditingController weekPriceController = TextEditingController();
  TextEditingController yearPriceController = TextEditingController();
  TextEditingController monthPriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String levelValue = "";
  String subjectValue = "";

  var levels = ['', 'cp1', 'cp2', 'ce1', 'ce2', 'cm1', 'cm2', '6eme', '5eme',
                '4eme', '3eme', 'seca', 'secc', '1erea', '1erec', '1ered',
                'tlea', 'tlec', 'tled', 'cafop', 'ena', 'infasbepc', 'infasbac'];
  var subjects = ['','all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st',
                  'cg', 'av', 'lm'];

  Future updateProduct() async{

    setState(() { launch = true; });
    String country = "Côte d'Ivoire";
    String name = nameController.text;
    String index = indexController.text;
    String level = levelController.text;
    String file = pdfFileController.text;
    String picture = pictureController.text;
    String subjects = subjectsController.text;
    String yearPrice = yearPriceController.text;
    String weekPrice = weekPriceController.text;
    String monthPrice = monthPriceController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];

    var response = await ProductRequests().updateProduct(name, description,
        weekPrice, monthPrice, yearPrice, date, level, subjects, picture, file,
        country, levelValue, subjectValue, index, product['productId']);

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
      String folder = "ressources";
      if(part == "pdfFile"){
        folder = "products";
      }

      String? name = result?.files.first.name;
      var fileBytes = result?.files.first.bytes;
      var fileName = "${name}_${DateTime.now().toString()
          .replaceAll(".", "").replaceAll(" ", "")
          .replaceAll("-", "")
          .replaceAll(":", "")}";

      String fileUrl = await (
          await FirebaseStorage.instance.ref().child('$folder/$fileName')
              .putData(fileBytes!)
              .whenComplete(() => null)).ref.getDownloadURL();

      setState(() {
        if(part == "product"){
          descriptionController.text = "${descriptionController.text}\n||\n[img]$fileUrl";
        }
        else if(part == "pdfFile"){
          pdfFileController.text = fileUrl;
        }
        else{
          pictureController.text = fileUrl;
        }
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

  void loadProduct(){
    setState(() {
      levelValue = product["levelAbr"];
      subjectValue = product["subjectAbr"];
      dateController.text = product["date"];
      nameController.text = product["name"];
      levelController.text = product["level"];
      indexController.text = product["index"];
      pdfFileController.text = product["file"];
      pictureController.text = product["picture"];
      subjectsController.text = product["subjects"];
      weekPriceController.text = product["weekPrice"];
      yearPriceController.text = product["yearPrice"];
      monthPriceController.text = product["monthPrice"];
      descriptionController.text = Utilities().changeInMark(product["description"]);
    });
  }

  @override
  void initState() {
    super.initState();
    product = widget.product;
    loadProduct();
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
                                controller: nameController,
                                decoration: const InputDecoration(
                                    labelText: "Nom",
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
                            Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                          controller: pdfFileController,
                                          decoration: const InputDecoration(
                                              labelText: "Fichier pdf",
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
                                        loadImages("pdfFile");
                                      },
                                      child: const Text("Ajouter le pdf")
                                  )
                                ]
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: weekPriceController,
                                decoration: const InputDecoration(
                                    labelText: "Prix Semaine",
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
                                controller: monthPriceController,
                                decoration: const InputDecoration(
                                    labelText: "Prix Mois",
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
                                controller: yearPriceController,
                                decoration: const InputDecoration(
                                    labelText: "Prix Année",
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
                                controller: subjectsController,
                                decoration: const InputDecoration(
                                    labelText: "Matieres",
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
                                controller: levelController,
                                decoration: const InputDecoration(
                                    labelText: "Niveau",
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
                                value: levelValue,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Niveau Abrégé",
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
                                  });
                                }
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: indexController,
                                decoration: const InputDecoration(
                                    labelText: "Index",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
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
                            const SizedBox(height: 15),
                            TextButton(
                                onPressed: (){
                                  loadImages("product");
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
                                      "Visualiser le produit",
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
                                  !launch ? updateProduct() : null;
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