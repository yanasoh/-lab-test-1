import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class sqlite{
  static const String _dbName = 'bitp3453_bmi' ;

  Database? _db;

  sqlite._();
  static final sqlite _instance = sqlite._();

  factory sqlite(){
    return _instance;
  }

  Future<Database> get database async{
    if (_db != null){
      return _db!;
    }
    String path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(path, version:1, onCreate: (createdDb, version) async {
      for (String tableSql in sqlite.tableSQLStrings){
        await createdDb.execute(tableSql);
      }
    },);
    return _db!;
  }

  static List<String> tableSQLStrings = [
    '''
    CREATE TABLE IF NOT EXISTS expense (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    weight DOUBLE,
    height DOUBLE,
    gender int,
    bmi_status TEXT)
    '''
  ];

  Future <int> insert (String tableName, Map<String, dynamic> row) async{
    Database db = await _instance.database;
    return await db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async{
    Database db = await _instance.database;
    return await db.query(tableName);
  }

  Future<int> update (String tableName, String idColumn, Map<String, dynamic> row) async{
    print ("\n SQLite Update Success");
    Database db = await _instance.database;
    dynamic id = row [idColumn];
    print ("\n ROW INFO:");
    row.forEach((key, value) {
      print ('$key: $value');
    });
    print ("\n SQLITE ID IS :" +id.toString());
    return await db.update(tableName, row, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> delete (String tableName, String idColumn, dynamic idValue) async{
    Database db = await _instance.database;
    print ("\n SQLITE delete sucess!");
    return await db.delete(tableName, where:'$idColumn = ?', whereArgs: [idValue]);
  }
}