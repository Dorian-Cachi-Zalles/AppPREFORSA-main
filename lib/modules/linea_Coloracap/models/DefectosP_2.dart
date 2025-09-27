    
class ModeloDatosColoracapDefectos_2 {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final int DistPosNom;
  final int Defecto;
  final int MaxDistrColor;
  final int Puntaje;
  final String hora;

  const ModeloDatosColoracapDefectos_2({
    this.id,
    required this.hasErrors,
    required this.hasSend,
    required this.cod_dpcalidad,
    required this.DistPosNom,
    required this.Defecto,
    required this.MaxDistrColor,
    required this.Puntaje,
    required this.hora
  });

  factory ModeloDatosColoracapDefectos_2.fromMap(Map<String, dynamic> map) {
    return ModeloDatosColoracapDefectos_2(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
      cod_dpcalidad: map['cod_dpcalidad'] as int,
      DistPosNom: map['DistPosNom'] as int,
      Defecto: map['Defecto'] as int,
      MaxDistrColor: map['MaxDistrColor'] as int,
      Puntaje: map['Puntaje'] as int,
      hora: map['hora'] as String
    );
  }

   ModeloDatosColoracapDefectos_2 copyWithForm(Map<String, dynamic> formValues, {bool? hasSend, bool? hasErrors}) {
    return ModeloDatosColoracapDefectos_2(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      DistPosNom: _toInt(formValues['DistPosNom']),
    Defecto: _toInt(formValues['Defecto']),
    MaxDistrColor: _toInt(formValues['MaxDistrColor']),
    Puntaje: _toInt(formValues['Puntaje']),
    hora: _toString(formValues['hora'])
    );
  }

   static String _toString(dynamic v) => v?.toString() ?? '';
  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
  

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'DistPosNom': DistPosNom,
      'Defecto': Defecto,
      'MaxDistrColor': MaxDistrColor,
      'Puntaje': Puntaje,
      'hora': hora
    };
  }

  ModeloDatosColoracapDefectos_2 copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,
    int? DistPosNom, int? Defecto, int? MaxDistrColor, int? Puntaje, String? hora
  }) {
    return ModeloDatosColoracapDefectos_2(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
      DistPosNom: DistPosNom ?? this.DistPosNom,
      Defecto: Defecto ?? this.Defecto,
      MaxDistrColor: MaxDistrColor ?? this.MaxDistrColor,
      Puntaje: Puntaje ?? this.Puntaje,
      hora: hora ?? this.hora
    );
  }
}


extension ModeloDatosColoracapDefectos_2Api on ModeloDatosColoracapDefectos_2 {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "DistPosNom": DistPosNom,
      "Defecto": Defecto,
      "MaxDistrColor": MaxDistrColor,
      "Puntaje": Puntaje,
      "hora": hora
    };
  }
}
