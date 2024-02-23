import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivepracagain/data.dart';
import 'package:hivepracagain/databoxes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  dataBox = await Hive.openBox<Data>('dataBox');
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true
      ),
      home: Homescreen(),
    );
  }
}

class Homescreen extends StatefulWidget {
   Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

var todocon = TextEditingController();

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do app'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextField(
            controller: todocon,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: const Text('To do')
            ),
          ),
          const Gap(10),
          ElevatedButton(onPressed: (){
            setState(() {
              dataBox.put('key_${todocon.text}', Data(name: todocon.text));
            });
          }, child: const Text('Add')),
          Expanded(
            child: ListView.builder(
              itemCount: dataBox.length,
              itemBuilder: (BuildContext context, int index) {
                Data data = dataBox.getAt(index);
                return Dismissible(
                  key: Key(data.name),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(context: context, builder: (_)=>
                    AlertDialog(
                      title: Text('Confirm Delete?'),
                      content: const Text('You are about to delete this item?'),
                      actions: [
                        ElevatedButton(onPressed: ()=> Navigator.of(context).pop(true), child: Text('Yes')),
                        ElevatedButton(onPressed: ()=> Navigator.of(context).pop(false), child: Text('No')),
                      ],
                    )
                    );
                  },
                  onDismissed: (direction) {
                    setState(() {
                      dataBox.deleteAt(index);
                    });
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(data.name),
                    ),
                  ),
                );
              },
            ),
          )
        ]
        ),
      ),
    );
  }
}