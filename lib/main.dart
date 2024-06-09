import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textcontroller = useTextEditingController();
    final db = FirebaseFirestore.instance;
    final docRef = db.collection('users').doc();
    final lists = useState([]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Center(
          child: Column(
        children: [
          const Text('Enter your name'),
          TextField(
            controller: _textcontroller,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint(_textcontroller.text);
              db.collection('users').doc().set({'name': _textcontroller.text});
            },
            child: const Text('Submit'),
          ),
          ElevatedButton(
            onPressed: () {
              db.collection('users').get().then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) {
                  lists.value.add(doc['name']);
                  debugPrint(doc['name']);
                });
              });
            },
            child: const Text("fetch data"),
          ),
          Divider(),
          ListView.builder(
            itemCount: lists.value.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(lists.value[index]),
              );
            },
          )
        ],
      )),
    );
  }
}
