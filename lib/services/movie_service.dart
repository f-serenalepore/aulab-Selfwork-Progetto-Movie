import 'package:moviesqlitemvvm/models/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBService {
  
  //Singleton Pattern: avremo una sola istanza di questa classe
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  //variabile che conterrà il DB SQLite. All'inizio è null
  static Database? _database;

  //getter asincrono: se il db è già stato aperto/è già esistente, lo restituisce. 
  //Altrimenti chiama _initDB, che lo inizializza. Alla fine lo restituisce.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    //Chiediamo al path provider il percorso della cartella cache dell'applicazione. 
    //Otteniamo un oggetto Directory
    final directory = await getApplicationDocumentsDirectory();
    //costruisce il percorso del file movies.db dentro quella directory
    final path = join(directory.path, 'movies.db');
    //se movies.db esiste già, lo apre, altrimenti crea il DB eseguendo on Create
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //metodo che crea la tabella movies
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE movies(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT NOT NULL,
      duration INTEGER NOT NULL,
      plot TEXT NOT NULL,
      year INTEGER NOT NULL)''');
  }

  //Operazioni CRUD

  //Create
  //future <int> perché restituisce l'id del film
  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    return await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Read
  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    final result = await db.query('movies');
    return result.map((map) => Movie.fromMap(map)).toList();
  }
  
  //Update
  Future<int> updateMovie(Movie movie) async {
    final db = await database;
    return db.update(
      'movies',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  //Delete
  Future<int> deleteMovie(int id) async {
    final db = await database;
    return await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}
