import 'package:flutter/material.dart';
import 'package:totale_reussite_admin/reclamation_achat_document.dart';
import 'package:totale_reussite_admin/reclamation_achat_question.dart';
import 'package:totale_reussite_admin/reclamation_premium_screen.dart';
import 'package:totale_reussite_admin/screens/articles/articles_screen.dart';
import 'package:totale_reussite_admin/screens/topics/admin_topics_screen.dart';
import 'package:totale_reussite_admin/screens/competition/admin_competition_screen.dart';

class ReclamationScreen extends StatefulWidget {
  const ReclamationScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<ReclamationScreen> createState() => ReclamationScreenState();
}

class ReclamationScreenState extends State<ReclamationScreen> {

  String uid = "";

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
            title: const Text("RECLAMATION DE TAKTIK SUCCESS")
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: 150,
                                child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              side: const BorderSide(color: Colors.grey)
                                          )
                                      )
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ReclamationAchatDocument(
                                                  uid: uid
                                              )
                                          )
                                      );
                                    },
                                    child: const Text(
                                        "Reclamation achat de document",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                )
                            )
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: SizedBox(
                                height: 150,
                                child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              side: const BorderSide(color: Colors.grey)
                                          )
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ReclamationPremiumScreen(
                                                  uid: uid
                                              )
                                          )
                                      );
                                    },
                                    child: const Text(
                                        "Reclamation achat premium",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                )
                            )
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: SizedBox(
                                height: 150,
                                child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                              side: const BorderSide(color: Colors.grey)
                                          )
                                      )
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => ReclamationAchatQuestionScreen(
                                                  uid: uid
                                              )
                                          )
                                      );
                                    },
                                    child: const Text(
                                        "Reclamation achat de question",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        )
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
