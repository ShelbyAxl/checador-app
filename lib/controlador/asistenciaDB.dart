import 'package:dam_u3_practica1_checador_asistencias/modelo/asistencia.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/asistenciaProfesor.dart';
import 'package:sqflite/sqflite.dart';
import 'conexion.dart';

class DBAsistencia {
  static Future<int> insertar(Asistencia a) async {
    Database base = await Conexion.abrirDB();
    return base.insert('ASISTENCIA', a.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar(int idasistencia) async {
    Database base = await Conexion.abrirDB();
    return base.delete('ASISTENCIA',
        where: 'IDASISTENCIA=?', whereArgs: [idasistencia]);
  }

  static Future<List<Asistencia>> mostrar() async {
    Database base = await Conexion.abrirDB();
    List<Map<String, dynamic>> resultado = await base.query('ASISTENCIA');
    return List.generate(resultado.length, (index) {
      return Asistencia(
          idasistencia: resultado[index]['IDASISTENCIA'],
          nhorario: resultado[index]['NHORARIO'],
          fecha: resultado[index]['FECHA'],
          asistencia: resultado[index]['ASISTENCIA']);
    });
  }

  static Future<List<AsistenciaProfesor>> mostrarConRelacion() async {
    Database base = await Conexion.abrirDB();
    List<Map<String, dynamic>> resultado = await base.rawQuery(
        'SELECT * FROM ASISTENCIA, HORARIO, PROFESOR, MATERIA WHERE ASISTENCIA.NHORARIO = HORARIO.NHORARIO AND HORARIO.NPROFESOR = PROFESOR.NPROFESOR AND HORARIO.NMAT = MATERIA.NMAT');
    return List.generate(resultado.length, (index) {
      return AsistenciaProfesor(
          idAsistenciaProfesor: resultado[index]['IDASISTENCIA'],
          nombre: resultado[index]['NOMBRE'],
          nmat: resultado[index]['NMAT'],
          fecha: resultado[index]['FECHA'],
          hora: resultado[index]['HORA'],
          asistencia: resultado[index]['ASISTENCIA']);
    });
  }
}
