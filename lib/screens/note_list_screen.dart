import 'package:flutter/material.dart';
import '../utils/db_helper.dart';
import '../models/note.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final db = DBHelper.instance;
    final data = await db.readAll();
    setState(() {
      notes = data;
    });
  }

  void _deleteNote(int id) async {
    final db = DBHelper.instance;
    await db.delete(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notlar')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(note.id!),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteEditScreen(note: note),
              ),
            ).then((_) => _loadNotes()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteEditScreen(),
          ),
        ).then((_) => _loadNotes()),
      ),
    );
  }
}
