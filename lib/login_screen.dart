import 'menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> emailPasswordSignIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginController.text,
          password: passwordController.text
      );

      if(!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenuScreen(
                uid: loginController.text
              )
          )
      );
    }
    on FirebaseAuthException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Connexion"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
                child: Column(
                    children: [
                      TextFormField(
                        controller: loginController,
                        decoration: const InputDecoration(
                          labelText: "Nom utilisateur",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.red)
                          )
                        )
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.red)
                          )
                        )
                      ),
                      const SizedBox(height: 10),
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
                              emailPasswordSignIn();
                            },
                            child: const Text(
                              "Se connecter",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        )
                      )
                    ]
                )
            ),
          )
        )
    );
  }
}
