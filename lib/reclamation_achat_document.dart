import 'package:flutter/material.dart';
import 'package:totale_reussite_admin/services/api_reclamation.dart';

class ReclamationAchatDocument extends StatefulWidget {
  const ReclamationAchatDocument({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<ReclamationAchatDocument> createState() => ReclamationAchatDocumentState();
}

class ReclamationAchatDocumentState extends State<ReclamationAchatDocument> {

  String uid = "";
  bool launch = false;
  bool seeInfo = false;
  String infoDocument = "";
  bool launchSearch = false;

  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController idDocController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  TextEditingController finishDateController = TextEditingController(
      text: "2024-02-29 00:00:00"
  );

  TextEditingController accountController = TextEditingController();
  TextEditingController formulaController = TextEditingController();
  TextEditingController transIdController = TextEditingController();
  TextEditingController transDateController = TextEditingController();
  TextEditingController operatorIdController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();

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

  Future addDoc() async{

    setState(() {
      launch = true;
    });

    String account = accountController.text;
    String transDate = transDateController.text;
    String docId = idDocController.text.trim();
    String formula = formulaController.text;
    String transId = transIdController.text;
    String expireDate = finishDateController.text;
    String operatorId = operatorIdController.text;
    String paymentMethod = paymentMethodController.text;
    String uid = idController.text.trim();

    bool value = await ReclamationRequests().addBuyDoc(account, transDate,
        docId, formula, transId, expireDate, operatorId, paymentMethod, uid);

    setState(() {
      if(value){
        infoDocument = "Achat ajouté avec succès";
      }
      else{
        infoDocument = "Error lors de l'ajout";
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
                            ),
                            const SizedBox(height: 15),
                            const Divider(),
                            const SizedBox(height: 15),
                            TextFormField(
                                controller: idDocController,
                                decoration: const InputDecoration(
                                    labelText: "Id du document",
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
                            TextFormField(
                                controller: accountController,
                                decoration: const InputDecoration(
                                    labelText: "Montant",
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
                            TextFormField(
                                controller: transDateController,
                                decoration: const InputDecoration(
                                    labelText: "Date de transaction",
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
                            TextFormField(
                                controller: formulaController,
                                decoration: const InputDecoration(
                                    labelText: "Formule",
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
                            TextFormField(
                                controller: transIdController,
                                decoration: const InputDecoration(
                                    labelText: "Id de transaction",
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
                            TextFormField(
                                controller: finishDateController,
                                decoration: const InputDecoration(
                                    labelText: "Date d'expiration",
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
                            TextFormField(
                                controller: operatorIdController,
                                decoration: const InputDecoration(
                                    labelText: "Id de l'operateur",
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
                            TextFormField(
                                controller: paymentMethodController,
                                decoration: const InputDecoration(
                                    labelText: "Methode de paiement",
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
                  const SizedBox(height: 25),
                  Center(
                      child: Text(
                          infoDocument,
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
                            addDoc();
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
