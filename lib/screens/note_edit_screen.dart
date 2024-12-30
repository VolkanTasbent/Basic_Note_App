import 'package:flutter/material.dart';
import '../utils/db_helper.dart';
import '../models/note.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;

  NoteEditScreen({this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    final db = DBHelper.instance;
    if (widget.note == null) {
      await db.create(
        Note(
          title: _titleController.text,
          content: _contentController.text,
        ),
      );
    } else {
      await db.update(
        Note(
          id: widget.note!.id,
          title: _titleController.text,
          content: _contentController.text,
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Not Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Başlık'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'İçerik'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
