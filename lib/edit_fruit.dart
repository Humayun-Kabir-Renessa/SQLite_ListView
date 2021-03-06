import 'package:flutter/material.dart';
import 'helper/db.dart';
import 'model/fruit.dart';

class EditFruit extends StatefulWidget {
  final Fruit fruit;
  EditFruit({required this.fruit});
  //const EditFruit({Key? key}) : super(key: key);

  @override
  _EditFruitState createState() => _EditFruitState();
}

class _EditFruitState extends State<EditFruit> {
  final _formKey = GlobalKey<FormState>();

  var fruitName = "";
  var fruitTaste = "";
  var fruitSeason = "";
  var db = DBHelper();

  @override
  Widget build(BuildContext context) {
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
          title: Text('Edit Fruit'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,0.0),
                child: TextFormField(
                  initialValue: widget.fruit.name,
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
                  initialValue: widget.fruit.taste,
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
                  initialValue: widget.fruit.season,
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
                      var tempFruit = Fruit(id: widget.fruit.id,name: fruitName, taste: fruitTaste, season: fruitSeason);
                      db.updateFruit(tempFruit);

                      // pop to home page
                      Navigator.pop(context,'true');

                    }
                  },
                  child: Text('UPDATE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
