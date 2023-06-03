import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final CollectionReference _notes = FirebaseFirestore.instance.collection('notes');

  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _descCont = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _titleCont.text = documentSnapshot['Title'];
      _descCont.text = documentSnapshot['Description'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext c) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(c).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleCont,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _descCont,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text("Update"),
                  onPressed: () async {
                    final String title = _titleCont.text;
                    final String description = _descCont.text;
                    final DateTime createTime = time;
                    await _notes.doc(documentSnapshot!.id).update({
                      "Title": title,
                      "Description": description,
                      "Create Time": createTime
                    });
                    _titleCont.text = '';
                    _descCont.text = '';
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _titleCont.text = documentSnapshot['Name'];
      _descCont.text = documentSnapshot['Price'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext c) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(c).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleCont,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _descCont,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text("Create"),
                  onPressed: () async {
                    final String title = _titleCont.text;
                    final String description = _descCont.text;
                    final DateTime createTime = time;
                    await _notes.add({
                      "Title": title,
                      "Description": description,
                      "Create Time": createTime
                    });
                    _titleCont.text = '';
                    _descCont.text = '';
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _notes.doc(productId).delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have successfully delete a product")));
  }

  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder(
        stream: _notes.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (c, i) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['Title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text(documentSnapshot['Description']),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(DateTime.parse(
                                      documentSnapshot['Create Time']
                                          .toDate()
                                          .toString())
                                  .hour
                                  .toString()),
                              const Text(":"),
                              Text(DateTime.parse(
                                      documentSnapshot['Create Time']
                                          .toDate()
                                          .toString())
                                  .minute
                                  .toString())
                            ],
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _update(documentSnapshot)),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(documentSnapshot.id)),
                          ],
                        ),
                      ),
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
    );
  }
}
