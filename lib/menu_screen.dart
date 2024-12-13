import 'package:flutter/material.dart';
import 'package:totale_reussite_admin/reclamation_screen.dart';
import 'package:totale_reussite_admin/screens/methods/method_screen.dart';
import 'package:totale_reussite_admin/screens/quiz/admin_quiz_screen.dart';
import 'package:totale_reussite_admin/screens/articles/articles_screen.dart';
import 'package:totale_reussite_admin/screens/topics/admin_topics_screen.dart';
import 'package:totale_reussite_admin/screens/courses/admin_course_screen.dart';
import 'package:totale_reussite_admin/screens/products/admin_product_screen.dart';
import 'package:totale_reussite_admin/screens/competition/admin_competition_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<MenuScreen> createState() => MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {

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
            title: const Text("ADMINISTRATION DE TAKTIK")
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
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey
                            ),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: ListTile(
                              title: Text(
                                  "Total Inscrit".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 15),
                                    Text(
                                        "30",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                  ]
                              )
                          )
                        )
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: ListTile(
                            title: Text(
                                "Inscrit aujourd'hui".toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold
                                )
                            ),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  SizedBox(height: 15),
                                  Text(
                                      "30",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                                ]
                            )
                        )
                      )
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey
                                ),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: ListTile(
                              title: Text(
                                  "Achat premium aujourd'hui".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 15),
                                    Text(
                                        "30",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        )
                                    )
                                  ]
                              )
                          )
                        )
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey
                                ),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: ListTile(
                              title: Text(
                                  "Achat document aujourd'hui".toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  SizedBox(height: 15),
                                  Text(
                                      "30",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                                ]
                              )
                          )
                        )
                    )
                  ]
                ),
                const SizedBox(height: 25),
                Row(
                    children: [
                      /*
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
                                            builder: (context) => const AdminClubScreen()
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES MATIERES",
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

                       */
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
                                            builder: (context) => AdminCourseScreen(
                                              uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES COURS",
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
                                            builder: (context) => AdminProductScreen(
                                                uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES DOCUMENTS",
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
                ),
                const SizedBox(height: 25),
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
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => AdminTopicScreen(
                                              uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES SUJETS",
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
                                            builder: (context) => AdminCompetitionScreen(
                                                uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES CONCOURS",
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
                                            builder: (context) => ArticleScreen(
                                              uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES ARTICLES",
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
                ),
                const SizedBox(height: 25),
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
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MethodScreen(
                                                uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES POINTS METHODES",
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
                                            builder: (context) => AdminQuizScreen(
                                              uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES QUIZ",
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
                      uid == 'archetechnology1011@gmail.com' ?
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
                                            builder: (context) => ReclamationScreen(
                                                uid: uid
                                            )
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES RECLAMATIONS",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              )
                          )
                      ) : const SizedBox()
                      /*
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
                                            builder: (context) => const MessageScreenScreen()
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES MESSAGES",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              )
                          )
                      )
                      Expanded(
                          child: SizedBox(
                              height: 150,
                              child: TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: const BorderSide(color: Colors.grey)
                                        )
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => const AdminClubScreen()
                                        )
                                    );
                                  },
                                  child: const Text(
                                      "GESTION DES CLUBS",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      )
                                  )
                              )
                          )
                      ),
                       */
                    ]
                )
              ]
          )
        )
    );
  }
}
