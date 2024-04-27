import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Conexion{
  static Future<Database> abrirDB() async {
    return openDatabase(join(await getDatabasesPath(), 'practica1.db'),
    onCreate: (db, version) {
      return script(db);
    }, version: 1
    );
  }

  static Future<void> script(Database db) async{
    db.execute('CREATE TABLE MATERIA(NMAT TEXT PRIMARY KEY, DESCRIPTION TEXT)');
    db.execute('CREATE TABLE PROFESOR(NPROFESOR TEXT PRIMARY KEY, NOMBRE TEXT, CARRERA TEXT)');
    db.execute('CREATE TABLE HORARIO(NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT, NPROFESOR TEXT, NMAT TEXT, HORA TEXT, EDIFICIO TEXT, SALON TEXT, FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR(NPROFESOR), FOREIGN KEY (NMAT) REFERENCES MATERIA(MMAT))');
    db.execute('CREATE TABLE ASISTENCIA(IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT, NHORARIO INT, FECHA TEXT, ASISTENCIA INT, FOREIGN KEY (NHORARIO) REFERENCES HORARIO(NHORARIO))');
  }
}