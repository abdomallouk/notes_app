import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes_app/models/note.dart';
import "package:path_provider/path_provider.dart";

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
  // Initialize the database connection
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // List all notes
  final List<Note> currentNotes = [];

  // Create a new note
  Future<void> addNote(String textFromUser) async {
    final newNote = Note()..text = textFromUser;
    await isar.writeTxn(() async {
      await isar.notes.put(newNote);
    });

    fetchNotes();
  }

  // Read all notes
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // Update an existing note
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() async {
        await isar.notes.put(existingNote);
      });
      await fetchNotes();
    }
  }

  // Delete a note by ID
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
    await fetchNotes();
  }
}
