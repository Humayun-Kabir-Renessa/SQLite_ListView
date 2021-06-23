import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_listview/model/fruit.dart';

class DBHelper{
  var database;

  Future<Database>initializeDB() async{
    return database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'fruits_database.db'),
      // When the database is first created, create a table to store fruits.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE fruits(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, taste TEXT, season TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Define a function that inserts fruits into the database
  Future<void> insertFruit(Fruit fruit) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Insert the Fruit into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same fruit is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'fruits',
      fruit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the fruits from the fruits table.
  Future<List<Fruit>> fruits() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all The Fruits.
    final List<Map<String, dynamic>> maps = await db.query('fruits');

    // Convert the List<Map<String, dynamic> into a List<Fruit>.
    return List.generate(maps.length, (i) {
      return Fruit(
        id: maps[i]['id'],
        name: maps[i]['name'],
        taste: maps[i]['taste'],
        season: maps[i]['season'],
      );
    });
  }

  Future<void> updateFruit(Fruit fruit) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Update the given Fruit.
    await db.update(
      'fruits',
      fruit.toMap(),
      // Ensure that the Fruit has a matching id.
      where: 'id = ?',
      // Pass the Fruit's id as a whereArg to prevent SQL injection.
      whereArgs: [fruit.id],
    );
  }

  Future<void> deleteFruit(int id) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Remove the Fruit from the database.
    await db.delete(
      'fruits',
      // Use a `where` clause to delete a specific fruit.
      where: 'id = ?',
      // Pass the Fruit's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}