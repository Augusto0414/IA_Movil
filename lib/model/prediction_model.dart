class PredictionModel {
  final String clase;
  final String descripcion;
  final Map<String, dynamic> caracteristicas;
  final List<List<dynamic>> probabilidades;

  PredictionModel({
    required this.clase,
    required this.descripcion,
    required this.caracteristicas,
    required this.probabilidades,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      clase: json['clase'] ?? 'Desconocida',
      descripcion: json['descripcion'] ?? 'Sin descripción disponible',
      caracteristicas: Map<String, dynamic>.from(json['caracteristicas'] ?? {}),
      probabilidades: List<List<dynamic>>.from((json['probabilidades'] ?? [])
          .map((x) => List<dynamic>.from(x.map((x) => x)))),
    );
  }
}
