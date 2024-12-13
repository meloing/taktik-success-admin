import 'package:flutter/material.dart';

class ReclamationAchatQuestionScreen extends StatefulWidget {
  const ReclamationAchatQuestionScreen({
    super.key,
    required this.uid
  });

  final String uid;

  @override
  State<ReclamationAchatQuestionScreen> createState() => ReclamationAchatQuestionScreenState();
}

class ReclamationAchatQuestionScreenState extends State<ReclamationAchatQuestionScreen> {

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
            title: const Text("RECLAMATION PREMIUM DE TAKTIK SUCCESS")
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                ]
            )
        )
    );
  }
}
