import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final CollectionReference chatting =
      FirebaseFirestore.instance.collection('chatting');

  final TextEditingController chatCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatting"),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: chatting.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (c, i) {
                    final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                            ),
                            color: Colors.green[200]),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(documentSnapshot['chat']),
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: chatCont,
                decoration: InputDecoration(
                  filled: true,
                    fillColor: Colors.white,
                    hintText: "Typing...Your Message",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: ([DocumentSnapshot? documentSnapshot]) async {
                        if (documentSnapshot != null) {
                          chatCont.text = documentSnapshot['chat'];
                        }
                        final String msg = chatCont.text;
                        await chatting.add({'chat':msg});
                        chatCont.text = "";
                      },
                    )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
