import 'package:flutter/material.dart';
import '../utils/db_helper.dart'; // Veritabanı işlemleri için yardımcı sınıf
import '../models/note.dart'; // Not modeli

// Not düzenleme ekranı Stateful bir widget olarak tanımlanıyor
class NoteEditScreen extends StatefulWidget {
  final Note? note; // Düzenlenecek not, null ise yeni not oluşturulacak

  NoteEditScreen({this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

// Not düzenleme ekranının durumu
class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController(); // Başlık için metin denetleyicisi
  final _contentController = TextEditingController(); // İçerik için metin denetleyicisi

  @override
  void initState() {
    super.initState();
    // Eğer düzenlenecek bir not varsa, metin denetleyicilerini bu notun verileriyle doldur
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  // Notu kaydetme işlemini gerçekleştirir
  void _saveNote() async {
    final db = DBHelper.instance; // Veritabanı yardımcısının örneğini al
    if (widget.note == null) {
      // Yeni not ekleme
      await db.create(
        Note(
          title: _titleController.text, // Başlık alanından metni al
          content: _contentController.text, // İçerik alanından metni al
        ),
      );
    } else {
      // Var olan notu güncelleme
      await db.update(
        Note(
          id: widget.note!.id, // Güncellenecek notun ID'si
          title: _titleController.text, // Yeni başlık
          content: _contentController.text, // Yeni içerik
        ),
      );
    }
    Navigator.pop(context); // Kaydetme işlemi tamamlandıktan sonra önceki ekrana dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Not Düzenle')), // Üst menü başlığı
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Ekranın iç kenar boşluğu
        child: Column(
          children: [
            // Başlık için metin girişi
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Başlık'), // Etiket
            ),
            // İçerik için metin girişi
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'İçerik'), // Etiket
            ),
            SizedBox(height: 20), // Dikey boşluk
            // Kaydetme düğmesi
            ElevatedButton(
              onPressed: _saveNote, // Düğmeye basıldığında notu kaydet
              child: Text('Kaydet'), // Düğme üzerindeki metin
            ),
          ],
        ),
      ),
    );
  }
}
