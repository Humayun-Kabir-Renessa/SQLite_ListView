import 'package:flutter/material.dart';
import 'package:sqlite_listview/add_fruit.dart';
import 'package:sqlite_listview/edit_fruit.dart';

import 'model/fruit.dart';
import 'helper/db.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite List View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FruitList(),
    );
  }
}

class FruitList extends StatefulWidget {
  const FruitList({Key? key}) : super(key: key);
   @override
  _FruitListState createState() => _FruitListState();
}

class _FruitListState extends State<FruitList> {
  var db = DBHelper();
  @override
  void initState(){
    var mango = Fruit(
        id: 0,
        name: 'mango',
        taste: 'sweet',
        season: '3 months'
    );
    var litchi = Fruit(
        id: 1,
        name: 'litchi',
        taste: 'sweet',
        season: '20 days'
    );
    //insertDB(mango);
    //insertDB(litchi);
    printFruit();

    // Update mango's season and save it to the database.
    mango = Fruit(
      id: mango.id,
      name: mango.name,
      taste: mango.taste,
      season: '2 months',
    );

    //updateDB(mango);
    //printFruit();

    //deleteDB(mango.id);
    //deleteDB(0);
    //deleteDB(1);
    //printFruit();

    super.initState();
  }

  insertDB(Fruit fruit) async{
    await db.insertFruit(fruit);
  }

  updateDB(Fruit fruit) async{
    await db.updateFruit(fruit);
  }

  deleteDB(int id) async{
    await db.deleteFruit(id);
  }

  printFruit() async{
    // Now, use the method above to retrieve all the dogs.
    print(await db.fruits());
  }
  
  Future<void> goToAddFruitScreen() async{
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddFruit()));
    if(result != null){
      print('refreshing home screen');
      setState(() {

      });
    }
  }

  Future<void> goToEditFruitScreen(Fruit fruit) async{
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditFruit(fruit: fruit)));
    if(result != null){
      print('refreshing home screen');
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
          centerTitle: true,
          title: Text('SQLite List View'),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: InkWell(
                  onTap: () {
                    // navigate to add fruit class
                    goToAddFruitScreen();
                    },
                  child: Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: FutureBuilder<List>(
          future: db.fruits(),
          //initialData: List(),
          builder: (context, snapshot) {
            //print('itemCount1 = ${snapshot.data?.length}');
            return snapshot.hasData ?
            new ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, i) {
                //print('itemCount2 = ${snapshot.data?.length}');
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: UniqueKey(),
                  child: InkWell(
                    onTap: (){
                      goToEditFruitScreen(snapshot.data?[i]);
                    },
                    child: new ListTile(
                      leading: Text('${snapshot.data?[i].id}'),
                      title: new Text(snapshot.data?[i].name),
                      subtitle: new Text(snapshot.data?[i].taste),
                      trailing: new Text(snapshot.data?[i].season),
                    ),
                  ),
                  background: Container(
                    padding: EdgeInsets.only(right: 28.0),
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Icon(Icons.delete_forever, color: Colors.white,),
                  ),
                  onDismissed: (direction) {
                    // TODO: implement your delete function and check direction if needed
                    //_deleteMessage(index);
                    snapshot.data?.remove(i);
                    db.deleteFruit(snapshot.data?[i].id).then((_){
                      setState(() {

                      });
                    });

                  },
                );
              },
            )
                : Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
  Widget _buildRow(Fruit fruit) {
    return ListTile(
      leading: Text('${fruit.id}'),
      title: new Text(fruit.name),
      subtitle: new Text(fruit.taste),
      trailing: new Text(fruit.season),
    );

    /*Dismissible(
      direction: DismissDirection.startToEnd,
      key: ObjectKey(snapshot.documents.elementAt(index)),
      child: new ListTile(
        leading: Text('${fruit.id}'),
        title: new Text(fruit.name),
        subtitle: new Text(fruit.taste),
        trailing: new Text(fruit.season),
      ),
      background: Container(
        padding: EdgeInsets.only(left: 28.0),
        alignment: AlignmentDirectional.centerStart,
        color: Colors.red,
        child: Icon(Icons.delete_forever, color: Colors.white,),
      ),
      onDismissed: (direction) {
        // TODO: implement your delete function and check direction if needed
        //_deleteMessage(index);
      },
    );*/
  }
}
