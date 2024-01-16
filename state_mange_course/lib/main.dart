import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
  final String id;
 // ValueNotifier
  final String name;
   Contact({
    required this.name,
  }): id = const Uuid().v4();
} 

class ContactBook extends ValueNotifier<List<Contact>>{

   ContactBook._sharedInstance() : super([]);

   static final ContactBook _shared = ContactBook._sharedInstance();

   factory ContactBook() => _shared;

//   final List<Contact> _contacts = [];

 // int get length => _contacts.length;
  int get length => value.length;

  void add({required Contact contact}){
    //final ValueNotifier notifier;
   // _contacts.add(contract);
    //value.add(contract);

    final contacts = value;
    contacts.add(contact);
    notifyListeners();
  }

  void remove({required Contact contact}){
   // _contacts.remove(contract);
   // value.remove(contract);

   final contacts = value;
   if(contacts.contains(contact)){
      contacts.remove(contact);
      notifyListeners();

   }
  }

    Contact? contract({required int atindex}) =>
    value.length > atindex ? value[atindex] : null;

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

      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
          
                return Dismissible(
                  onDismissed: (direction) {
                    contacts.remove(contact);
                  },
                  key: ValueKey(contact.id),
                  child: Material(
                    color: Colors.white,
                    elevation: 6.0,
                    child: ListTile(
                      title: Text(contact.name),
                    ),
                  ),
                );
            },
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
              ContactBook().add(contact:contact );
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

