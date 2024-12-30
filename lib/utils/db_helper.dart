import 'package:sqflite/sqflite.dart'; // SQLite işlemleri için gerekli paket
import 'package:path/path.dart'; // Veritabanı yolu oluşturmak için gerekli paket
import '../models/note.dart'; // Note modelini içe aktarma

// Veritabanı işlemlerini yöneten sınıf
class DBHelper {
  static final DBHelper instance = DBHelper._init(); // Singleton tasarım deseniyle sınıfın tek bir örneğini oluşturur.
  static Database? _database; // Veritabanı nesnesi (başlangıçta null)

  DBHelper._init(); // Özel bir kurucu, dışarıdan çağrılamaz.

  // Veritabanı nesnesini döndürür, eğer veritabanı yoksa oluşturur.
  Future<Database> get database async {
    if (_database != null) return _database!; // Veritabanı zaten varsa döndür
    _database = await _initDB('notes.db'); // Veritabanını başlat
    return _database!;
  }

  // Veritabanını başlatır.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); // Cihazdaki veritabanı dizinini al
    final path = join(dbPath, filePath); // Veritabanı dosyasının tam yolunu oluştur

    // Veritabanını aç ve oluşturma işlemini bağla
    return await openDatabase(
      path,
      version: 1, // Veritabanı sürümü
      onCreate: _createDB, // Veritabanı ilk kez oluşturulduğunda çalışacak fonksiyon
    );
  }

  // Veritabanı oluşturma fonksiyonu
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT, // Otomatik artan birincil anahtar
        title TEXT NOT NULL, // Başlık alanı (Boş bırakılamaz)
        content TEXT NOT NULL // İçerik alanı (Boş bırakılamaz)
      )
    ''');
  }

  // Yeni bir not oluşturur.
  Future<int> create(Note note) async {
    final db = await instance.database; // Veritabanını al
    return await db.insert('notes', note.toMap()); // Notu 'notes' tablosuna ekle
  }

  // Tüm notları okur ve bir liste olarak döndürür.
  Future<List<Note>> readAll() async {
    final db = await instance.database; // Veritabanını al
    final result = await db.query('notes'); // 'notes' tablosundan tüm verileri al

    // Her bir kaydı Note nesnesine dönüştür ve liste olarak döndür
    return result.map((map) => Note.fromMap(map)).toList();
  }

  // Var olan bir notu günceller.
  Future<int> update(Note note) async {
    final db = await instance.database; // Veritabanını al
    return db.update(
      'notes', // Güncellenecek tablo
      note.toMap(), // Güncellenecek veriler
      where: 'id = ?', // Hangi kaydın güncelleneceğini belirtir
      whereArgs: [note.id], // Güncellenecek kaydın id'si
    );
  }

  // Bir notu siler.
  Future<int> delete(int id) async {
    final db = await instance.database; // Veritabanını al
    return db.delete(
      'notes', // Silinecek tablo
      where: 'id = ?', // Hangi kaydın silineceğini belirtir
      whereArgs: [id], // Silinecek kaydın id'si
    );
  }
}
