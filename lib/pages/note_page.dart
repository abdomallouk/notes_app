import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // Text controller to access what the user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Read notes from the database when the page is initialized
    readNotes();
  }

  // Create a note
  void createNote() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(controller: textController),
            actions: [
              // Create button
              MaterialButton(
                onPressed: () {
                  // Add to database
                  context.read<NoteDatabase>().addNote(textController.text);

                  // Clear the text field
                  textController.clear();

                  // Close dialog
                  Navigator.pop(context);
                },
                child: const Text("Create"),
              ),
            ],
          ),
    );
  }

  // reaad notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // Update a note

  // delete a note

  @override
  Widget build(BuildContext context) {
    final notesDatabase = context.watch<NoteDatabase>();

    List<Note> currentNotes = notesDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        actions: [
          IconButton(onPressed: createNote, icon: const Icon(Icons.add)),
          IconButton(onPressed: readNotes, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          final note = currentNotes[index];
          return ListTile(
            title: Text(note.text),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                notesDatabase.deleteNote(note.id);
              },
            ),
          );
        },
      ),
    );
  }
}
