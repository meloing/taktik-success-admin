import 'package:flutter/material.dart';
import 'package:totale_reussite_admin/services/api_reclamation.dart';

class ReclamationPremiumScreen extends StatefulWidget {
  const ReclamationPremiumScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<ReclamationPremiumScreen> createState() => ReclamationPremiumScreenState();
}

class ReclamationPremiumScreenState extends State<ReclamationPremiumScreen> {

  String uid = "";
  bool launch = false;
  bool seeInfo = false;
  String infoPremium = "";
  bool launchSearch = false;
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  TextEditingController finishDateController = TextEditingController(
    text: "2024-02-29 00:00:00"
  );

  Future getUserByEmail() async{
    setState(() {
      launchSearch = true;
    });

    String email = mailController.text;
    List values = await ReclamationRequests().getUserByEmail(email);

    setState(() {
      if(values.isNotEmpty){
        Map value = values[0];
        idController.text = value["uid"];
        pseudoController.text = value["pseudo"];
        nameController.text = value["firstName"] + " " + value["lastName"];
      }

      seeInfo = true;
      launchSearch = false;
    });
  }

  Future updateUserPremium() async {

    setState(() {
      launch = true;
    });

    String userId = idController.text;
    String date = finishDateController.text;
    bool value = await ReclamationRequests().updateUserPremium(userId, date);

    setState(() {
      if(value){
        infoPremium = "Premium mise à jour avec succès";
      }
      else{
        infoPremium = "Error lors de la mise à jour";
      }

      launch = false;
    });
  }

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Text("RECLAMATION PREMIUM DE TAKTIK SUCCESS")
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      " - Demander le reçu de paiement du client.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                  ),
                  const Text(
                      " - Verifier que le paiement à été fait.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const Text(
                      " - Demander l'adresse mail du client et le rechercher.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const Text(
                      " - Selectionner la date de finition et enregistrer.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                            controller: mailController,
                            decoration: const InputDecoration(
                                labelText: "Adresse mail",
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
                      const SizedBox(width: 5),
                      SizedBox(
                        height: 50,
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.blue
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                )
                            ),
                            onPressed: (){
                              getUserByEmail();
                            },
                            child: !launchSearch ?
                            const Text(
                                "Rechercher",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                )
                            ) :
                            const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white
                                )
                            )
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 15),
                  Visibility(
                      visible: seeInfo,
                      child: Column(
                        children: [
                          TextFormField(
                              readOnly: true,
                              controller: idController,
                              decoration: const InputDecoration(
                                  labelText: "Id",
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
                              readOnly: true,
                              controller: pseudoController,
                              decoration: const InputDecoration(
                                  labelText: "Pseudo",
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
                              readOnly: true,
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: "Nom complet",
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
                        ]
                      )
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                      controller: finishDateController,
                      decoration: const InputDecoration(
                          labelText: "Date de fin",
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
                  const SizedBox(height: 25),
                  Center(
                    child: Text(
                        infoPremium,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 40,
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
                          updateUserPremium();
                          /*
                        if(_registerFormKey.currentState!.validate()){
                          !launch ? addTopic() : null;
                        }

                         */
                        },
                        child: !launch ?
                        const Text(
                            "Valider",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        ) :
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white
                          )
                        )
                    )
                  )
                ]
            )
        )
    );
  }
}
