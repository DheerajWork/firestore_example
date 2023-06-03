import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  TextEditingController noteCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: TextFormField(
                controller: noteCont,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Add Notes"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  var note = noteCont.text.trim();
                  if (note != "") {
                    try {
                      await FirebaseFirestore.instance
                          .collection("notes")
                          .doc()
                          .set({"CreatedAt": DateTime.now(), "note": note});
                    } catch (e) {
                      print("Error $e");
                    }
                  }
                },
                child: const Text("Add Note"))
          ],
        ),
      ),
    );
  }
}
