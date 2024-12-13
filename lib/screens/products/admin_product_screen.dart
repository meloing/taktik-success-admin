import 'add_product_screen.dart';
import 'package:flutter/material.dart';
import '../../services/api_product.dart';
import 'package:totale_reussite_admin/screens/products/update_product_screen.dart';

class AdminProductScreen extends StatefulWidget {
  const AdminProductScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<AdminProductScreen> createState() => AdminProductScreenState();
}

class AdminProductScreenState extends State<AdminProductScreen> {
  String uid = "";
  List products = [];
  String env = "Prod";

  Future addProductToProd(Map product) async{
    String date = product["date"];
    String name = product["name"];
    String file = product["file"];
    String level = product["level"];
    String index = product["index"];
    String country = product["country"];
    String docId = product["productId"];
    String picture = product["picture"];
    String levelAbr = product["levelAbr"];
    String subjects = product["subjects"];
    String weekPrice = product["weekPrice"];
    String yearPrice = product["yearPrice"];
    String subjectAbr = product["subjectAbr"];
    String monthPrice = product["monthPrice"];
    String description = product["description"];

    await ProductRequests().addProduct(name, description, weekPrice, monthPrice,
                                       yearPrice, date, level, subjects, picture,
                                       file, country, levelAbr, subjectAbr, index,
                                       env, docId);

    await ProductRequests().updateStatus(docId, "Prod");
  }

  Future getProducts() async{
    List values = await ProductRequests().getProducts();
    setState(() {
      products.addAll(values);
    });
  }

  void modal(Map e){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Attention !!!"),
          content: const Text(
              "Attention le produit sera disponible pour tous."
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
                  addProductToProd(e);
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
    getProducts();
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
                      "GESTION DES PRODUITS",
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
                        onPressed: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const AddProductScreen()
                              )
                          );
                        },
                        child: const Text(
                            "Ajouter un produit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            )
                        )
                    )
                  ),
                  const SizedBox(height: 15),
                  Column(
                      children: products.map(
                              (e) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                          onPressed: (){
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => UpdateProductScreen(
                                                        product: e
                                                    )
                                                )
                                            );
                                          },
                                          child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                        e['name'].toLowerCase(),
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
                                          modal(e);
                                        },
                                        icon: const Icon(
                                            Icons.add_rounded
                                        )
                                    ):
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
                          )
                      ).toList()
                  )
                ]
            )
        )
    );
  }
}