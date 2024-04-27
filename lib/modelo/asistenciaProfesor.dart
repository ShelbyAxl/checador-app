class AsistenciaProfesor {
  int idAsistenciaProfesor;
  String nombre;
  String nmat;
  String fecha;
  String hora;
  int asistencia;

  AsistenciaProfesor({
    required this.idAsistenciaProfesor,
    required this.nombre,
    required this.nmat,
    required this.fecha,
    required this.hora,
    required this.asistencia,
  });

  Map<String, dynamic> toJSON(){
    return {
      // 'idAsistenciaProfesor': idAsistenciaProfesor,
      'nombre': nombre,
      'nmat' : nmat,
      'fecha': fecha,
      'hora': hora,
      'asistencia': asistencia,
    };
  }
}
