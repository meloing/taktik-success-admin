import '../../services/api_club.dart';
import 'package:flutter/material.dart';

class AddClubScreen extends StatefulWidget {
  const AddClubScreen({super.key});

  @override
  State<AddClubScreen> createState() => AddClubScreenState();
}

class AddClubScreenState extends State<AddClubScreen> {
  bool launch = false;
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future addClub() async{

    setState(() { launch = true; });
    String icon = "ena.png";
    String name = nameController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];
    await ClubRequests().addClub(name, description, icon, date);

    setState(() {
      launch = false;
      nameController.text = "";
      descriptionController.text = "";
    });
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
                      "AJOUTER UN CLUB",
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
                                controller: nameController,
                                decoration: const InputDecoration(
                                    labelText: "Nom",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        borderSide: BorderSide(color: Colors.red)
                                    )
                                )
                            ),
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
                              !launch ? addClub() : null;
                            }
                          },
                          child: !launch ? const Text(
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