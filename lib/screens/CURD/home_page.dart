import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_example/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? img;
  final String? number;

  const HomePage({this.userName, Key? key, this.email, this.img, this.number})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _priceCont = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameCont.text = documentSnapshot['Name'];
      _priceCont.text = documentSnapshot['Price'].toString();
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
                  controller: _nameCont,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceCont,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text("Update"),
                  onPressed: () async {
                    final String name = _nameCont.text;
                    final double? price = double.tryParse(_priceCont.text);
                    if (price != null) {
                      await _products
                          .doc(documentSnapshot!.id)
                          .update({"Name": name, "Price": price});
                      _nameCont.text = '';
                      _priceCont.text = '';
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameCont.text = documentSnapshot['Name'];
      _priceCont.text = documentSnapshot['Price'];
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
                TextFormField(
                  controller: _nameCont,
                  decoration: const InputDecoration(labelText: 'Name',),
                ),
                TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceCont,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text("Create"),
                    onPressed: () async {
                      final String name = _nameCont.text;
                      final double? price = double.tryParse(_priceCont.text);
                      if (price != null) {
                        await _products.add({"Name": name, "Price": price});
                        _nameCont.text = '';
                        _priceCont.text = '';
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You have successfully delete a product")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        elevation: 8,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple,
                  image: DecorationImage(image: NetworkImage(widget.img!))),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.userName}"),
                const SizedBox(
                  height: 4,
                ),
                Text("${widget.email}", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: ()async{
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const AuthScreen()));
            },
            icon: const Icon(Icons.power_settings_new),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
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
                    elevation: 5,
                    color: Colors.orange,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['Name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(documentSnapshot['Price'].toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _update(documentSnapshot)),
                            IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
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
