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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
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
              TextFormField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
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
              TextFormField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      print('fruit name = $fruitName, fruit taste = $fruitTaste, fruit season = $fruitSeason');
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      var tempFruit = Fruit(id: 3,name: fruitName, taste: fruitTaste, season: fruitSeason);
                      db.insertFruit(tempFruit);

                      // pop to home page
                      Navigator.pop(context,'true');

                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
