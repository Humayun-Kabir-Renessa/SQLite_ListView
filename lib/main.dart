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
    super.initState();
  }
// method to insert a Fruit into SQLite Database
  insertDB(Fruit fruit) async{
    await db.insertFruit(fruit);
  }
// method to update a Fruit into SQLite Database
  updateDB(Fruit fruit) async{
    await db.updateFruit(fruit);
  }
// method to delete a Fruit into SQLite Database
  deleteDB(int id) async{
    await db.deleteFruit(id);
  }

  printFruit() async{
    // Now, use the method above to retrieve all the fruits.
    print(await db.fruits());
  }

  // This method is responsible to navigate to AddFruitPage.
  // this method will wait for add action from AddFruitPage.
  // If add button is clicked, it will refresh home screen to
  // add new fruit into list view
  Future<void> goToAddFruitScreen() async{
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddFruit()));
    if(result != null){
      // refreshing list view
      setState(() {

      });
    }
  }
  // This method is responsible to navigate to EditFruitPage.
  // this method will wait for update action from EditFruitPage.
  // If update button is clicked, it will refresh home screen to
  // edit fruit into list view
  Future<void> goToEditFruitScreen(Fruit fruit) async{
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditFruit(fruit: fruit)));
    if(result != null){
     // refreshing list view
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
                    setState(() {
                      goToAddFruitScreen();
                    });
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
          builder: (context, snapshot) {
            return snapshot.hasData ?
            new ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, i) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: UniqueKey(),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        goToEditFruitScreen(snapshot.data?[i]);
                      });
                    },
                    child: Card(
                      elevation: 2.0,
                      child: new ListTile(
                        leading: Text('${snapshot.data?[i].id}'),
                        title: new Text(snapshot.data?[i].name),
                        subtitle: new Text(snapshot.data?[i].taste),
                        trailing: new Text(snapshot.data?[i].season),
                      ),
                    ),
                  ),
                  background: Container(
                    padding: EdgeInsets.only(right: 28.0),
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Icon(Icons.delete_forever, color: Colors.white,),
                  ),
                  onDismissed: (direction) {
                    db.deleteFruit(snapshot.data?[i].id);

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
}
