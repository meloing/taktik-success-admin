import '../../services/api_club.dart';
import 'add_club_screen.dart';
import 'package:flutter/material.dart';
import 'package:totale_reussite_admin/screens/clubs/update_club_screen.dart';

class AdminClubScreen extends StatefulWidget {
  const AdminClubScreen({super.key});

  @override
  State<AdminClubScreen> createState() => AdminClubScreenState();
}

class AdminClubScreenState extends State<AdminClubScreen> {
  List clubs = [];

  Future getClubs() async{
    List values = await ClubRequests().getClubs();
    setState(() {
      clubs.addAll(values);
    });
  }

  @override
  void initState() {
    super.initState();
    getClubs();
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
                      "GESTION DES CLUBS",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const AddClubScreen()
                            )
                        );
                      },
                      child: const Text(
                          "Ajouter un club"
                      )
                  ),
                  Column(
                      children: clubs.map(
                              (e) => Column(
                              children: [
                                TextButton(
                                    onPressed: (){
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => UpdateClubScreen(
                                                  club: e
                                              )
                                          )
                                      );
                                    },
                                    child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  e['clubName'].toLowerCase(),
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