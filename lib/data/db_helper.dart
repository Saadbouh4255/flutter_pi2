import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/tourist_place.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tourist_places.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // version 2 to include mapsLien
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';

    await db.execute('''
CREATE TABLE places (
  id $idType,
  name $textType,
  imagePath $textType,
  description $textType,
  category $textType,
  mapsLien $textNullable
)
''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE places ADD COLUMN mapsLien TEXT');
    }
  }

  Future<void> insertPlace(TouristPlace place) async {
    final db = await instance.database;
    await db.insert(
      'places',
      place.toJson()..['id'] = place.id,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPlaces(List<TouristPlace> places) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.delete('places'); // Full sync with remote by clearing deleted items
      for (var place in places) {
        await txn.insert(
          'places',
          place.toJson()..['id'] = place.id,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

// Top-level function to parse DB maps
List<TouristPlace> _parseDbMaps(List<Map<String, Object?>> maps) {
  return maps.map((map) => TouristPlace.fromJson(map)).toList();
}

  Future<List<TouristPlace>> getAllPlaces() async {
    final db = await instance.database;
    final List<Map<String, Object?>> allMaps = [];
    
    // Fetch in chunks of 5 to avoid platform channel memory limits with huge base64 images
    int offset = 0;
    const limit = 5;
    while (true) {
      final maps = await db.query('places', limit: limit, offset: offset);
      if (maps.isEmpty) break;
      allMaps.addAll(maps);
      offset += limit;
    }

    return _parseDbMaps(allMaps);
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('places');
  }
}
