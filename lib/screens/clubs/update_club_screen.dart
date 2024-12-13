import 'package:flutter/material.dart';
import '../../services/api_club.dart';

class UpdateClubScreen extends StatefulWidget {
  const UpdateClubScreen({
    super.key,
    required this.club
  });

  final Map club;

  @override
  State<UpdateClubScreen> createState() => UpdateClubScreenState();
}

class UpdateClubScreenState extends State<UpdateClubScreen> {
  Map club = {};
  bool launch = false;
  final _registerFormKey = GlobalKey<FormState>();
  TextEditingController iconController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void loadClub(){
    setState(() {
      iconController.text = club["clubIcon"];
      nameController.text = club["clubName"];
      descriptionController.text = club["clubDescription"];
    });
  }

  Future updateClub() async{

    setState(() { launch = true; });
    String icon = "ena.png";
    String name = nameController.text;
    String description = descriptionController.text;
    String date = DateTime.now().toString().split(".")[0];
    await ClubRequests().updateClub(name, description, icon, date, club['clubId']);

    setState(() {
      launch = false;
    });
  }

  @override
  void initState() {
    super.initState();
    club = widget.club;
    loadClub();
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
                                    labelText: "Description du club",
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
                              !launch ? updateClub() : null;
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
                ]
            )
        )
    );
  }
}