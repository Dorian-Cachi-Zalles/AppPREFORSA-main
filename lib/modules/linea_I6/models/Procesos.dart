class ModeloParametros {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String hora;
  final int cod_producto;
  final List<double> tempTolvaSeccionada;
  final double tempProduccion;
  final double tiempoCiclo;
  final double tiempoEnfriamento;
  final bool isConcatenado;
  final String? pa;

  const ModeloParametros(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,
      required this.hora,
      required this.cod_producto,
      required this.tempTolvaSeccionada,
      required this.tempProduccion,
      required this.tiempoCiclo,
      required this.tiempoEnfriamento,
      required this.isConcatenado,
      required this.pa});

  factory ModeloParametros.fromMap(Map<String, dynamic> map) {
    return ModeloParametros(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
      cod_dpcalidad: map['cod_dpcalidad'] as int,
      hora: map['hora'] as String,
      cod_producto: map['cod_producto'] as int,
      tempTolvaSeccionada: (map['tempTolvaSeccionada'] as String)
          .split(',')
          .where((item) => item.isNotEmpty)
          .map(double.parse)
          .toList(),
      tempProduccion: map['tempProduccion'] as double,
      tiempoCiclo: map['tiempoCiclo'] as double,
      tiempoEnfriamento: map['tiempoEnfriamento'] as double,
      isConcatenado: map['isConcatenado'] == 1,
      pa: map['pa'] as String,
    );
  }

  ModeloParametros copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend, bool? hasErrors, List<double>? tempTolvaSeccionada}) {
    return ModeloParametros(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      hora: _toString(formValues['hora']),
      cod_producto: cod_producto,
      tempTolvaSeccionada: tempTolvaSeccionada ?? this.tempTolvaSeccionada,
      tempProduccion: _toDouble(formValues['tempProduccion']),
      tiempoCiclo: _toDouble(formValues['tiempoCiclo']),
      tiempoEnfriamento: _toDouble(formValues['tiempoEnfriamento']),
      isConcatenado: isConcatenado,
      pa: pa,
    );
  }

  static String _toString(dynamic v) => v?.toString() ?? '';
  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'hora': hora,
      'cod_producto': cod_producto,
      'tempTolvaSeccionada': tempTolvaSeccionada.join(','),
      'tempProduccion': tempProduccion,
      'tiempoCiclo': tiempoCiclo,
      'tiempoEnfriamento': tiempoEnfriamento,
      'isConcatenado': isConcatenado ? 1 : 0,
      'pa': pa,
    };
  }

  ModeloParametros copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? cod_dpcalidad,
      String? hora,
      int? cod_producto,
      List<double>? tempTolvaSeccionada,
      double? tempProduccion,
      double? tiempoCiclo,
      double? tiempoEnfriamento,
      bool? isConcatenado,
      String? pa}) {
    return ModeloParametros(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
        hora: hora ?? this.hora,
        cod_producto: cod_producto ?? this.cod_producto,
        tempTolvaSeccionada: tempTolvaSeccionada ?? this.tempTolvaSeccionada,
        tempProduccion: tempProduccion ?? this.tempProduccion,
        tiempoCiclo: tiempoCiclo ?? this.tiempoCiclo,
        tiempoEnfriamento: tiempoEnfriamento ?? this.tiempoEnfriamento,
        isConcatenado: isConcatenado ?? this.isConcatenado,
        pa: pa ?? this.pa);
  }
}

extension ModeloParametrosApi on ModeloParametros {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "hora": hora,
      "cod_producto": cod_producto,
      "tempTolvaSeccionada": tempTolvaSeccionada,
      "tempProduccion": tempProduccion,
      "tiempoCiclo": tiempoCiclo,
      "tiempoEnfriamento": tiempoEnfriamento
    };
  }
}
