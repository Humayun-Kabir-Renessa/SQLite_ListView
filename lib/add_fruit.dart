import 'package:flutter/material.dart';
import 'package:sqlite_listview/model/fruit.dart';
import 'helper/db.dart';

class AddFruit extends StatefulWidget {
  const AddFruit({Key? key}) : super(key: key);

  @override
  _AddFruitState createState() => _AddFruitState();
}

class _AddFruitState extends State<AddFruit> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var fruitName = "";
  var fruitTaste = "";
  var fruitSeason = "";
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Add Fruit',
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
              child: Icon(Icons.arrow_back_ios)
          ),
          centerTitle: true,
          title: Text('Add Fruit'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),
                child: TextFormField(

                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Fruit Name'
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Fruit Name';
                    }
                    fruitName = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Fruit taste'
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Fruit taste';
                    }
                    fruitTaste = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter fruit season'
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fruit season';
                    }
                    fruitSeason = value;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, insert fruit into SQLite Database.
                      var tempFruit = Fruit(id: 3,name: fruitName, taste: fruitTaste, season: fruitSeason);
                      db.insertFruit(tempFruit);

                      // pop to home page
                      Navigator.pop(context,'true');

                    }
                  },
                  child: Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
