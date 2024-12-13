import 'add_method_screen.dart';
import 'package:flutter/material.dart';
import '../../services/api_methods.dart';
import 'package:totale_reussite_admin/screens/methods/update_method_screen.dart';

class MethodScreen extends StatefulWidget {
  const MethodScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<MethodScreen> createState() => MethodScreenState();
}

class MethodScreenState extends State<MethodScreen> {
  String uid = "";
  List methods = [];

  Future addMethodToProd(int index) async{
    String type = methods[index]["type"];
    String date = methods[index]["date"];
    String title = methods[index]["title"];
    String docId = methods[index]["methodId"];
    String subject = methods[index]["subject"];
    String subtitle = methods[index]["subtitle"];
    String description = methods[index]["description"];

    await MethodsRequests().addMethod(title, description, subtitle, date,
                                      subject, type, "Prod", docId);

    await MethodsRequests().updateStatus(docId, "Prod");

    setState(() {
      methods[index]["env"] == "Prod";
    });
  }

  Future getMethods() async{
    List values = await MethodsRequests().getMethods();

    setState(() {
      methods.addAll(values);
    });
  }

  void modal(int index){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention !!!"),
          content: const Text(
              "Attention le point méthode sera disponible pour tous."
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
                  addMethodToProd(index);
                  Navigator.of(context).pop();
                },
                child: const Text("Valider")
            )
          ]
        )
    );
  }

  @override
  void initState() {
    super.initState();
    getMethods();
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
                      "GESTION DES POINTS METHODES",
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
                                  builder: (context) => const AddMethodScreen()
                              )
                          );
                          if(value != null && value.isNotEmpty){
                            setState(() {
                              methods.addAll(value);
                            });
                          }
                        },
                        child: const Text(
                            "Ajouter un point methode",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        )
                    )
                  ),
                  const SizedBox(height: 15),
                  Column(
                      children: Iterable.generate(methods.length).toList().map(
                              (index) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                          onPressed: ()async{
                                            var value = await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => UpdateMethodScreen(
                                                        method: methods[index]
                                                    )
                                                )
                                            );

                                            if(value != null){
                                              setState(() {
                                                methods[index] = value;
                                              });
                                            }
                                          },
                                          child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        methods[index]['title'].toLowerCase(),
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
                                    ) :
                                    const SizedBox(),
                                    Icon(
                                        Icons.circle,
                                        color: methods[index]["env"] == null ? Colors.red :
                                        methods[index]["env"] == "Prod" ? Colors.green : Colors.red
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