import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/new-contact': (context) => const NewContactView(),
      },
    );
  }
}

class Contact{
  final String name;
  const Contact({
    required this.name,
  });
} 

class ContactBook{

   ContactBook._sharedInstance();

   static final ContactBook _shared = ContactBook._sharedInstance();

   factory ContactBook() => _shared;

   final List<Contact> _contacts = [];

  int get length => _contacts.length;

  void add({required Contact contract}){
    _contacts.add(contract);
  }

  void remove({required Contact contract}){
    _contacts.remove(contract);
  }

    Contact? contract({required int atindex}) =>
    _contacts.length > atindex ? _contacts[atindex] : null;

}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    final contactBook = ContactBook();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text("Home Page"),
      ),

      body: ListView.builder(
        itemCount: contactBook.length,
        itemBuilder: (context, index) {
          final contract = contactBook.contract(atindex: index)!;

            return ListTile(
              title: Text(contract.name),
            );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/new-contact');
        },
        child: Icon(Icons.add),
      ),




    );
  }
}














//.......................................................................

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {

  late final TextEditingController _controller;

  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New contact'),
      ),

      body: Column(

        children: [

          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter a new conract name here...',
            ),
          ),

          TextButton(
            onPressed: () {
              final contact = Contact(name: _controller.text);
              ContactBook().add(contract:contact );
              Navigator.of(context).pop();
            }, 
            child: Text(
              'Add Contract'
            ) 
          )

        ],
      ),
    );
  }
}

