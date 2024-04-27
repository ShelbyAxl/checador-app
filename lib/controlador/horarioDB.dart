import 'package:dam_u3_practica1_checador_asistencias/modelo/asistenciaHorarioMateria.dart';
import 'package:dam_u3_practica1_checador_asistencias/modelo/horario.dart';
import 'package:sqflite/sqflite.dart';
import 'conexion.dart';

class DBHorario {
  static Future<int> insertar(Horario a) async {
    Database base = await Conexion.abrirDB();
    return base.insert('HORARIO', a.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar(int nhorario) async {
    Database base = await Conexion.abrirDB();
    return base.delete('HORARIO', where: 'NHORARIO=?', whereArgs: [nhorario]);
  }

  static Future<List<Horario>> mostrar() async {
    try {
      Database base = await Conexion.abrirDB();
      List<Map<String, dynamic>> resultado = await base.query('HORARIO');
      return List.generate(resultado.length, (index) {
        return Horario(
            nhorario: resultado[index]['NHORARIO'],
            nprofesor: resultado[index]['NPROFESOR'],
            nmat: resultado[index]['NMAT'],
            hora: resultado[index]['HORA'],
            edificio: resultado[index]['EDIFICIO'],
            salon: resultado[index]['SALON']);
      });
    } catch (e) {
      print('Error en la obtención de datos de Horario: ${e}');
      throw e;
    }
  }

  static Future<List<ProfesorHorarioMateria>> mostrarConRelacion() async {
    try {
      Database base = await Conexion.abrirDB();
      List<Map<String, dynamic>> resultado = await base.rawQuery(
          'SELECT * FROM HORARIO, PROFESOR, MATERIA WHERE HORARIO.NPROFESOR = PROFESOR.NPROFESOR AND HORARIO.NMAT = MATERIA.NMAT');
      return List.generate(resultado.length, (index) {
        return ProfesorHorarioMateria(
            nhorario: resultado[index]['NHORARIO'],
            nombreProfesor: resultado[index]['NOMBRE'],
            nombreMateria: resultado[index]['NMAT']);
      });
    } catch (e) {
      print('Error en la obtención de datos de Horario con relación: ${e}');
      throw e;
    }
  }
}
