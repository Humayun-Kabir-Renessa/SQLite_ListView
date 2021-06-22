import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_listview/model/fruit.dart';
import 'package:flutter/material.dart';
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

  // Define a function that inserts dogs into the database
  Future<void> insertFruit(Fruit fruit) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'fruits',
      fruit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Fruit>> fruits() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all The Dogs.
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

    // Update the given Dog.
    await db.update(
      'fruits',
      fruit.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [fruit.id],
    );
  }

  Future<void> deleteFruit(int id) async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Remove the Dog from the database.
    await db.delete(
      'fruits',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}