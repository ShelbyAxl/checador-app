class ProfesorHorarioMateria {
  int nhorario;
  String hora;
  String nombreProfesor;
  String nombreMateria;

  ProfesorHorarioMateria({
    required this.nhorario,
    required this.hora,
    required this.nombreProfesor,
    required this.nombreMateria,
  });

  Map<String, dynamic> toJSON(){
    return {
      'nhorario': nhorario,
      'hora': hora,
      'nombreProfesor': nombreProfesor,
      'nombreMateria' : nombreMateria,
    };
  }
}
