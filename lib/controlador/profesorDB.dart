import 'package:sqflite/sqflite.dart';
import 'conexion.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/profesor.dart';

class DBProfesor {
  static Future<int> insertar(Profesor a) async {
    Database base = await Conexion.abrirDB();
    return base.insert('PROFESOR', a.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar(String nprofesor) async {
    Database base = await Conexion.abrirDB();
    return base
        .delete('PROFESOR', where: 'NPROFESOR=?', whereArgs: [nprofesor]);
  }

  static Future<List<Profesor>> mostrar() async {
    Database base = await Conexion.abrirDB();
    List<Map<String, dynamic>> resultado = await base.query('PROFESOR');
    return List.generate(resultado.length, (index) {
      return Profesor(
          nprofesor: resultado[index]['NPROFESOR'],
          nombre: resultado[index]['NOMBRE'],
          carrera: resultado[index]['CARRERA']);
    });
  }
}
