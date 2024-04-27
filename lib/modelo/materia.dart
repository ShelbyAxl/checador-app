class Materia {
  String nmat;
  String description;

  Materia({
    required this.nmat,
    required this.description,
  });

  Map<String, dynamic> toJSON() {
    return {
      'nmat': nmat,
      'description': description,
    };
  }
}
