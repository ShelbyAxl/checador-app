class ProfesorHorarioMateria {
  int nhorario;
  String nombreProfesor;
  String nombreMateria;

  ProfesorHorarioMateria({
    required this.nhorario,
    required this.nombreProfesor,
    required this.nombreMateria,
  });

  Map<String, dynamic> toJSON(){
    return {
      'hhorario': nhorario,
      'nombreProfesor': nombreProfesor,
      'nombreMateria' : nombreMateria,
    };
  }
}
