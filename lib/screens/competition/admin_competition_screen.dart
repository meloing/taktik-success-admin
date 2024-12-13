import 'add_competition_screen.dart';
import 'package:flutter/material.dart';
import '../../services/api_competition.dart';
import 'package:totale_reussite_admin/screens/competition/update_competition_screen.dart';

class AdminCompetitionScreen extends StatefulWidget {
  const AdminCompetitionScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<AdminCompetitionScreen> createState() => AdminCompetitionScreenState();
}

class AdminCompetitionScreenState extends State<AdminCompetitionScreen> {
  String uid = "";
  String env = "Prod";
  List competition = [];

  Future addCompetitionToProd(int index) async{
    String date = competition[index]["date"];
    String link = competition[index]["link"];
    String name = competition[index]["name"];
    String picture = competition[index]["picture"];
    String country = competition[index]["country"];
    String contacts = competition[index]["contacts"];
    String docId = competition[index]["competitionId"];
    String description = competition[index]["description"];

    await CompetitionRequests().addCompetition(name, description, link, date,
                                               contacts, picture, country, env,
                                               docId);
    await CompetitionRequests().updateStatus(docId, "Prod");

    setState(() {
      competition[index]["env"] = "Prod";
    });
  }

  Future getCompetition() async{
    List values = await CompetitionRequests().getCompetition();
    setState(() {
      competition.addAll(values);
    });
  }

  void modal(int index){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention !!!"),
          content: const Text(
              "Attention le concours sera disponible pour tous."
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("Annuler")
            ),
            TextButton(
                onPressed: (){
                  addCompetitionToProd(index);
                  Navigator.of(context).pop();
                },
                child: const Text("Valider")
            )
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getCompetition();
    uid = widget.uid;
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
                      "GESTION DES CONCOURS",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 15),
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
                        onPressed: ()async{
                          var value = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const AddCompetitionScreen()
                              )
                          );

                          if(value != null && value.isNotEmpty){
                            setState(() {
                              competition.addAll(value);
                            });
                          }
                        },
                        child: const Text(
                            "Ajouter un concours",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            )
                        )
                    )
                  ),
                  const SizedBox(height: 15),
                  Column(
                      children: Iterable.generate(competition.length).toList().map(
                              (index) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                          onPressed: ()async{
                                            var value = await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => UpdateCompetitionScreen(
                                                        competition: competition[index]
                                                    )
                                                )
                                            );

                                            if(value != null){
                                              setState(() {
                                                competition[index] = value;
                                              });
                                            }
                                          },
                                          child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        competition[index]['name'].toLowerCase(),
                                                        textAlign: TextAlign.justify,
                                                        style:  const TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.black
                                                        )
                                                    )
                                                ),
                                                const SizedBox(width: 10),
                                                const Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    color: Colors.grey
                                                )
                                              ]
                                          )
                                      )
                                    ),
                                    uid == 'archetechnology1011@gmail.com' ?
                                    IconButton(
                                        onPressed: (){
                                          modal(index);
                                        },
                                        icon: const Icon(
                                            Icons.add_rounded
                                        )
                                    ):
                                    const SizedBox(),
                                    Icon(
                                        Icons.circle,
                                        color: competition[index]["env"] == null ? Colors.red :
                                        competition[index]["env"] == "Prod" ? Colors.green : Colors.red
                                    )
                                  ]
                                ),
                                const Divider()
                              ]
                          )
                      ).toList()
                  )
                ]
            )
        )
    );
  }
}