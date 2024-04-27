class Horario {
  int nhorario;
  String nprofesor;
  String nmat;
  String hora;
  String edificio;
  String salon;

  Horario({
    required this.nhorario,
    required this.nprofesor,
    required this.nmat,
    required this.hora,
    required this.edificio,
    required this.salon,
  });

  Map<String, dynamic> toJSON(){
    return {
      // 'nhorario': nhorario,
      'nprofesor': nprofesor,
      'nmat': nmat,
      'hora': hora,
      'edificio': edificio,
      'salon': salon,
    };
  }
}
