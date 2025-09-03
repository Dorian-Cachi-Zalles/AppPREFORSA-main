class ModeloTemperatura {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String hora;
  final String fase;
  final List<int> cavidades;
  final List<double> tempCuerpo;
  final List<double> tempCuello;

  const ModeloTemperatura(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,
      required this.hora,
      required this.fase,
      required this.cavidades,
      required this.tempCuerpo,
      required this.tempCuello});

  factory ModeloTemperatura.fromMap(Map<String, dynamic> map) {
    return ModeloTemperatura(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        cod_dpcalidad: map['cod_dpcalidad'] as int,
        hora: map['hora'] as String,
        fase: map['fase'] as String,
        cavidades: (map['cavidades'] as String)
            .split(',')
            .where((item) => item.isNotEmpty)
            .map(int.parse)
            .toList(),
        tempCuerpo: (map['tempCuerpo'] as String)
            .split(',')
            .where((item) => item.isNotEmpty)
            .map(double.parse)
            .toList(),
        tempCuello: (map['tempCuello'] as String)
            .split(',')
            .where((item) => item.isNotEmpty)
            .map(double.parse)
            .toList());
  }

  ModeloTemperatura copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend,
      bool? hasErrors,
      List<int>? cavidades,
      List<double>? tempCuerpo,
      List<double>? tempCuello}) {
    return ModeloTemperatura(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      hora: _toString(formValues['hora']),
      fase: _toString(formValues['fase']),
      cavidades: cavidades ?? this.cavidades,
      tempCuerpo: tempCuerpo ?? this.tempCuello,
      tempCuello: tempCuello ?? this.tempCuello,
    );
  }

  static String _toString(dynamic v) => v?.toString() ?? '';

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'hora': hora,
      'fase': fase,
      'cavidades': cavidades.join(','),
      'tempCuerpo': tempCuerpo.join(','),
      'tempCuello': tempCuello.join(',')
    };
  }

  ModeloTemperatura copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? cod_dpcalidad,
      String? hora,
      String? fase,
      List<int>? cavidades,
      List<double>? tempCuerpo,
      List<double>? tempCuello}) {
    return ModeloTemperatura(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
        hora: hora ?? this.hora,
        fase: fase ?? this.fase,
        cavidades: cavidades ?? this.cavidades,
        tempCuerpo: tempCuerpo ?? this.tempCuerpo,
        tempCuello: tempCuello ?? this.tempCuello);
  }
}

extension ModeloTemperaturaApi on ModeloTemperatura {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "hora": hora,
      "fase": fase,
      "cavidades": cavidades,
      "tempCuerpo": tempCuerpo,
      "tempCuello": tempCuello
    };
  }
}
