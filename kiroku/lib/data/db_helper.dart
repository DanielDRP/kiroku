import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/anime.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'anime_library.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE anime(
            id INTEGER PRIMARY KEY,
            malId INTEGER,
            title TEXT,
            titleEnglish TEXT,
            titleJapanese TEXT,
            imageUrl TEXT,
            type TEXT,
            episodes INTEGER,
            status TEXT,
            score REAL,
            synopsis TEXT,
            year INTEGER,
            genres TEXT,
            dateAdded TEXT,
            progress INTEGER,
            isFavorite INTEGER,
            listType INTEGER
          )
        ''');
      }
    );
  }

  Future<void> insertAnime(Anime anime) async {
    final dbClient = await db;
    await dbClient.insert(
      'anime',
      anime.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Anime>> getAllAnimes() async {
    final dbClient = await db;
    final result = await dbClient.query('anime');
    return result.map((e) => Anime.fromMap(e)).toList();
  }

  Future<void> updateAnime(Anime anime) async {
    final dbClient = await db;
    await dbClient.update(
      'anime',
      anime.toMap(),
      where: 'id = ?',
      whereArgs: [anime.id],
    );
  }

  Future<void> deleteAnime(int id) async {
    final dbClient = await db;
    await dbClient.delete('anime', where: 'id = ?', whereArgs: [id]);
  }
}