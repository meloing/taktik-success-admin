import 'add_topic_screen.dart';
import 'package:flutter/material.dart';
import '../../services/api_topics.dart';
import 'package:totale_reussite_admin/screens/topics/update_topic_screen.dart';

class AdminTopicScreen extends StatefulWidget {
  const AdminTopicScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<AdminTopicScreen> createState() => AdminTopicScreenState();
}

class AdminTopicScreenState extends State<AdminTopicScreen> {
  String uid = "";
  List topics = [];
  String env = "Prod";
  String level = 'cp1';
  String subject = "all";

  var items = ['cp1', 'cp2', 'ce1', 'ce2', 'cm1', 'cm2', '6eme', '5eme',
               '4eme', '3eme', 'seca', 'secc', '1erea', '1erec', '1ered',
               'tlea', 'tlec', 'tled', 'cafop', 'ena', 'infasbepc', 'infasbac'];

  var subjects = ['all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st',
                  'cg', 'av', 'lm'];

  Future addTopicToProd(index) async{
    Map topic = topics[index];

    String date = topic["date"];
    String type = topic["type"];
    List level = topic["level"];
    String title = topic["title"];
    String docId = topic["topicId"];
    int topicIndex = topic["index"];
    String subject = topic["subject"];
    String exercise = topic["exercise"];
    String fileType = topic["fileType"];
    String correction = topic["correction"];
    String description = topic["description"];

    await TopicsRequests().addTopic(title, description, subject, date, level,
                                    exercise, correction, type, fileType, topicIndex,
                                    env, docId);
    await TopicsRequests().updateStatus(docId, "Prod");

    setState(() {
      topics[index]["env"] = "Prod";
    });
  }

  Future getTopics() async{
    List values = await TopicsRequests().getTopics(level, subject);
    /*
    for(Map topic in values){
      String fileTypeValue = "";
      String typeValue = topic["type"];
      List topicLevels = topic["level"];
      String subjectValue = topic["subject"];
      String date = "2023-09-16 11:43:42";
      String title = topic["title"];
      String exercise = Utilities().changeInMark(topic["exercise"]);
      String correction = Utilities().changeInMark(topic["correction"]);
      String description = topic["description"];

      if(topic.containsKey("fileType")){
        fileTypeValue = topic["fileType"];
      }
      else{
        fileTypeValue = "picture_text|picture_text";
      }

      await TopicsRequests().updateTopic(title, description, subjectValue,
          date, topicLevels, exercise, correction, typeValue, fileTypeValue,
          topic["topicId"]);
    }

     */
    setState(() {
      topics.clear();
      topics.addAll(values);
    });
  }

  void modal(index){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention !!!"),
          content: const Text(
              "Attention le sujet sera disponible pour tous."
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
                  addTopicToProd(index);
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
                      "GESTION DES SUJETS",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(
                      height: 50,
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
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const AddTopicScreen()
                                )
                            );
                          },
                          child: const Text(
                              "Ajouter un sujet",
                              style: TextStyle(
                                  color: Colors.white
                              )
                          )
                      )
                  ),
                  const SizedBox(height: 15),
                  Row(
                      children: [
                        Expanded(
                            child: DropdownButtonFormField(
                                value: subject,
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
                                    subject = newValue!;
                                  });
                                }
                            )
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                            child: DropdownButtonFormField(
                                value: level,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                    labelText: "Niveau",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    )
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    level = newValue!;
                                  });
                                }
                            )
                        ),
                        const SizedBox(width: 15),
                        IconButton(
                            onPressed: (){
                              getTopics();
                            },
                            icon: const Icon(
                                Icons.search_rounded
                            )
                        ),
                        const SizedBox(width: 15)
                      ]
                  ),
                  const SizedBox(height: 15),
                  Column(
                      children: Iterable<int>.generate(topics.length).toList().map(
                              (index){
                                Map e = topics[index];
                                return Column(
                                    children: [
                                      Row(
                                          children: [
                                            Expanded(
                                                child: TextButton(
                                                    onPressed: (){
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) => UpdateTopicScreen(
                                                                  topic: e
                                                              )
                                                          )
                                                      );
                                                    },
                                                    child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                      e['title'].toLowerCase(),
                                                                      textAlign: TextAlign.justify,
                                                                      style:  const TextStyle(
                                                                          fontSize: 17,
                                                                          color: Colors.black
                                                                      )
                                                                  ),
                                                                  const SizedBox(height: 5),
                                                                  Text(e['description'].toLowerCase())
                                                                ]
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
                                            ) :
                                            const SizedBox(),
                                            Icon(
                                                Icons.circle,
                                                color: e["env"] == null ? Colors.red :
                                                e["env"] == "Prod" ? Colors.green : Colors.red
                                            )
                                          ]
                                      ),
                                      const Divider()
                                    ]
                                );
                              }
                      ).toList()
                  )
                ]
            )
        )
    );
  }
}