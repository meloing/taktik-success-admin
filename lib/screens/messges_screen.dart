import 'package:flutter/material.dart';

class MessageScreenScreen extends StatefulWidget {
  const MessageScreenScreen({super.key});

  @override
  State<MessageScreenScreen> createState() => MessageScreenScreenState();
}

class MessageScreenScreenState extends State<MessageScreenScreen> {
  String path = "";
  List levels = [];
  bool launch = false;
  String topicValue = "";
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController exercisesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var topics = ['', 'cp1', 'cp2', 'ce1', 'ce2', 'cm1', 'cm2', '6eme', '5eme',
               '4eme', '3eme', 'seca', 'secc', '1erea', '1erec', '1ered',
               'tlea', 'tlec', 'tled', 'cafop', 'ena', 'infasbepc', 'infasbac'];

  Future sendMessage() async{

    setState(() { launch = true; });

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
                      "ENVOYER DES MESSAGES",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 15),
                  Form(
                      key: _registerFormKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                                controller: titleController,
                                decoration: const InputDecoration(
                                    labelText: "Titre du message",
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
                                controller: numberController,
                                decoration: const InputDecoration(
                                    labelText: "Corps du message",
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
                                value: topicValue,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Topics",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10))
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: topics.map((String item) {
                                  return DropdownMenuItem(
                                      value: item,
                                      child: Text(item)
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    topicValue = newValue!;
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
                              !launch ? sendMessage() : null;
                            }
                          },
                          child: !launch ? const Text(
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
                ]
            )
        )
    );
  }
}
