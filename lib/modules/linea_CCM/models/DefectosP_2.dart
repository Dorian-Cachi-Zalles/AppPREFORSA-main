    
class ModeloDatosCcmDef2 {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final String hora;
  final int cod_dpcalidad;
  final int MaxDistrColor;
  final int PtsNegroPeq;
  final int PtsNegroMed;
  final int Puntuacion_0;
  final int Puntuacion_1;
  final int Excentricidad;
  final int DistIntMax;
  final int DistExtMax;
  final int Puntuacion_2;
  final int Puntuacion_3;
  final int AmplBandaBrill;

  const ModeloDatosCcmDef2({
    this.id,
    required this.hasErrors,
    required this.hasSend,
    required this.hora,
    required this.cod_dpcalidad,
    required this.MaxDistrColor,
    required this.PtsNegroPeq,
    required this.PtsNegroMed,
    required this.Puntuacion_0,
    required this.Puntuacion_1,
    required this.Excentricidad,
    required this.DistIntMax,
    required this.DistExtMax,
    required this.Puntuacion_2,
    required this.Puntuacion_3,
    required this.AmplBandaBrill
  });

  factory ModeloDatosCcmDef2.fromMap(Map<String, dynamic> map) {
    return ModeloDatosCcmDef2(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
       hora: map['hora'] as String,
      cod_dpcalidad: map['cod_dpcalidad'] as int,
      MaxDistrColor: map['MaxDistrColor'] as int,
      PtsNegroPeq: map['PtsNegroPeq'] as int,
      PtsNegroMed: map['PtsNegroMed'] as int,
      Puntuacion_0: map['Puntuacion_0'] as int,
      Puntuacion_1: map['Puntuacion_1'] as int,
      Excentricidad: map['Excentricidad'] as int,
      DistIntMax: map['DistIntMax'] as int,
      DistExtMax: map['DistExtMax'] as int,
      Puntuacion_2: map['Puntuacion_2'] as int,
      Puntuacion_3: map['Puntuacion_3'] as int,
      AmplBandaBrill: map['AmplBandaBrill'] as int
    );
  }

   ModeloDatosCcmDef2 copyWithForm(Map<String, dynamic> formValues, {bool? hasSend, bool? hasErrors}) {
    return ModeloDatosCcmDef2(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
       hora: _toString(formValues['hora']),
      MaxDistrColor: _toInt(formValues['MaxDistrColor']),
    PtsNegroPeq: _toInt(formValues['PtsNegroPeq']),
    PtsNegroMed: _toInt(formValues['PtsNegroMed']),
    Puntuacion_0: _toInt(formValues['Puntuacion_0']),
    Puntuacion_1: _toInt(formValues['Puntuacion_1']),
    Excentricidad: _toInt(formValues['Excentricidad']),
    DistIntMax: _toInt(formValues['DistIntMax']),
    DistExtMax: _toInt(formValues['DistExtMax']),
    Puntuacion_2: _toInt(formValues['Puntuacion_2']),
    Puntuacion_3: _toInt(formValues['Puntuacion_3']),
    AmplBandaBrill: _toInt(formValues['AmplBandaBrill'])
    );
  }
  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
  static String _toString(dynamic v) => v?.toString() ?? ''; 


  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'hora': hora,
      'MaxDistrColor': MaxDistrColor,
      'PtsNegroPeq': PtsNegroPeq,
      'PtsNegroMed': PtsNegroMed,
      'Puntuacion_0': Puntuacion_0,
      'Puntuacion_1': Puntuacion_1,
      'Excentricidad': Excentricidad,
      'DistIntMax': DistIntMax,
      'DistExtMax': DistExtMax,
      'Puntuacion_2': Puntuacion_2,
      'Puntuacion_3': Puntuacion_3,
      'AmplBandaBrill': AmplBandaBrill
    };
  }

  ModeloDatosCcmDef2 copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,
    String? hora,
    int? MaxDistrColor, int? PtsNegroPeq, int? PtsNegroMed, int? Puntuacion_0, int? Puntuacion_1, int? Excentricidad, int? DistIntMax, int? DistExtMax, int? Puntuacion_2, int? Puntuacion_3, int? AmplBandaBrill
  }) {
    return ModeloDatosCcmDef2(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
       hora: hora ?? this.hora,
      MaxDistrColor: MaxDistrColor ?? this.MaxDistrColor,
      PtsNegroPeq: PtsNegroPeq ?? this.PtsNegroPeq,
      PtsNegroMed: PtsNegroMed ?? this.PtsNegroMed,
      Puntuacion_0: Puntuacion_0 ?? this.Puntuacion_0,
      Puntuacion_1: Puntuacion_1 ?? this.Puntuacion_1,
      Excentricidad: Excentricidad ?? this.Excentricidad,
      DistIntMax: DistIntMax ?? this.DistIntMax,
      DistExtMax: DistExtMax ?? this.DistExtMax,
      Puntuacion_2: Puntuacion_2 ?? this.Puntuacion_2,
      Puntuacion_3: Puntuacion_3 ?? this.Puntuacion_3,
      AmplBandaBrill: AmplBandaBrill ?? this.AmplBandaBrill
    );
  }
}


extension ModeloDatosCcmDef2Api on ModeloDatosCcmDef2 {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
       "hora": hora,
      "MaxDistrColor": MaxDistrColor,
      "PtsNegroPeq": PtsNegroPeq,
      "PtsNegroMed": PtsNegroMed,
      "Puntuacion_0": Puntuacion_0,
      "Puntuacion_1": Puntuacion_1,
      "Excentricidad": Excentricidad,
      "DistIntMax": DistIntMax,
      "DistExtMax": DistExtMax,
      "Puntuacion_2": Puntuacion_2,
      "Puntuacion_3": Puntuacion_3,
      "AmplBandaBrill": AmplBandaBrill
    };
  }
}
