import 'conexion.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/materia.dart';
import 'package:sqflite/sqflite.dart';

class DBMateria {
  static Future<int> insertar(Materia a) async {
    Database base = await Conexion.abrirDB();
    return base.insert('MATERIA', a.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar(String nmat) async {
    Database base = await Conexion.abrirDB();
    return base.delete('MATERIA', where: 'NMAT=?', whereArgs: [nmat]);
  }

  static Future<List<Materia>> mostrar() async {
    Database base = await Conexion.abrirDB();
    List<Map<String, dynamic>> resultado = await base.query('MATERIA');
    return List.generate(resultado.length, (index) {
      return Materia(
          nmat: resultado[index]['NMAT'],
          description: resultado[index]['DESCRIPTION']);
    });
  }
}
