import 'add_course_screen.dart';
import 'package:flutter/material.dart';
import '../../services/api_course.dart';
import 'package:totale_reussite_admin/screens/courses/update_course_screen.dart';

class AdminCourseScreen extends StatefulWidget {
  const AdminCourseScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<AdminCourseScreen> createState() => AdminCourseScreenState();
}

class AdminCourseScreenState extends State<AdminCourseScreen> {
  String uid = "";
  List courses = [];
  String env = "Prod";
  String level = 'cp1';
  String subject = "all";

  var items = ['cp1', 'cp2', 'ce1', 'ce2', 'cm1', 'cm2', '6eme', '5eme',
               '4eme', '3eme', 'seca', 'secc', '1erea', '1erec', '1ered',
               'tlea', 'tlec', 'tled', 'cafop', 'ena', 'infasbepc', 'infasbac'];

  var subjects = ['all', 'fr', 'hg', 'pc', 'edhc', 'esp', 'philo', 'tic',
                  'tice', 'eps', 'ang', 'svt', 'mus', 'maths', 'art', 'st',
                  'cg', 'av', 'lm'];

  void modal(index){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention !!!"),
          content: const Text(
              "Attention le cours sera disponible pour tous."
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
                  addCourseToProd(index);
                  Navigator.of(context).pop();
                },
                child: const Text("Valider")
            )
          ]
        )
    );
  }

  Future addCourseToProd(index) async{
    Map course = courses[index];

    String type = course["type"];
    String date = course["date"];
    List level = course["level"];
    String title = course["title"];
    String docId = course["courseId"];
    String subject = course["subject"];
    String exercises = course["exercises"];
    String description = course["description"];

    await CourseRequests().addCourse(level, title, subject, description,
                                     date, exercises, type, env, docId);

    await CourseRequests().updateStatus(docId, "Prod");

    setState(() {
      courses[index]["env"] = "Prod";
    });
  }

  Future getCourses(String part) async{
    List values;
    if(part == "direct"){
      values = await CourseRequests().getCourses();
    }
    else{
      values = await CourseRequests().getSpecificCourses(level, subject);
    }

    /*
    List users = await CourseRequests().getUsers();
    print(users.length);
    int i = 0;

    for(Map<String, dynamic> user in users){
      if(user["docId"] != user["uid"]){
        print("c'est fini");
        String docId = user["docId"];
        user.remove('docId');
        bool response = await CourseRequests().addUser(user);

        if(response){
          await CourseRequests().deleteUser(docId);
        }
      }
      else{
        i = i + 1;
        print(i);
      }
    }

    for(Map course in values){
      String typeValue = course["type"];
      List levels = course["level"];
      String subjectValue = course["subject"];
      String date = "2023-10-15 11:43:42";
      String title = course["title"];
      String exercises = Utilities().changeInMark(course["exercises"]);
      String description = Utilities().changeInMark(course["description"]);

      await CourseRequests().updateCourse(levels, title, subjectValue,
          description, date, exercises, typeValue, course["courseId"]);
    }
    */
    
    setState(() {
      courses.clear();
      courses.addAll(values);
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
            title: const Text("Admin")
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text(
                      "GESTION DES COURS",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 15),
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
                                  builder: (context) => const AddCourseScreen()
                              )
                          );
                        },
                        child: const Text(
                            "Ajouter un cours",
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
                            getCourses("search");
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
                      children: Iterable<int>.generate(courses.length).toList().map(
                              (index) {
                                Map e = courses[index];
                                return Column(
                                    children: [
                                      Row(
                                          children: [
                                            Expanded(
                                                child: TextButton(
                                                    onPressed: (){
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) => UpdateCourseScreen(
                                                                  course: e
                                                              )
                                                          )
                                                      );
                                                    },
                                                    child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                  e['title'].toString().toLowerCase(),
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
                                                color: e["env"] == null ? Colors.red :
                                                e["env"] == "Prod" ? Colors.green : Colors.red
                                            )
                                          ]
                                      ),
                                      Text(e["type"]),
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