class ModeloColoranteCCM {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String colorante;
  final String codigo;
  final String lote;
  final double dosificacion;
  final int cantidadBolsone;

  const ModeloColoranteCCM(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,
      required this.colorante,
      required this.codigo,
      required this.lote,      
      required this.dosificacion,
      required this.cantidadBolsone});

  factory ModeloColoranteCCM.fromMap(Map<String, dynamic> map) {
    return ModeloColoranteCCM(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        cod_dpcalidad: map['cod_dpcalidad'] as int,
        colorante: map['colorante'] as String,
        codigo: map['codigo'] as String,
        lote: map['lote'] as String,        
        dosificacion: map['dosificacion'] as double,
        cantidadBolsone: map['cantidadBolsone'] as int);
  }

  ModeloColoranteCCM copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend, bool? hasErrors}) {
    return ModeloColoranteCCM(
        id: id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad,
        colorante: _toString(formValues['colorante']),
        codigo: _toString(formValues['codigo']),
        lote: _toString(formValues['lote']),       
        dosificacion: _toDouble(formValues['dosificacion']),
        cantidadBolsone: _toInt(formValues['cantidadBolsone']));
  }

  static String _toString(dynamic v) => v?.toString() ?? '';
  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

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
      'colorante': colorante,
      'codigo': codigo,
      'lote': lote,      
      'dosificacion': dosificacion,
      'cantidadBolsone': cantidadBolsone
    };
  }

  ModeloColoranteCCM copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? cod_dpcalidad,
      String? colorante,
      String? codigo,
      String? lote,
      String? bp,
      double? dosificacion,
      int? cantidadBolsone}) {
    return ModeloColoranteCCM(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
        colorante: colorante ?? this.colorante,
        codigo: codigo ?? this.codigo,
        lote: lote ?? this.lote,      
        dosificacion: dosificacion ?? this.dosificacion,
        cantidadBolsone: cantidadBolsone ?? this.cantidadBolsone);
  }
}

extension ModeloColoranteCCMApi on ModeloColoranteCCM {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "colorante": colorante,
      "codigo": codigo,
      "kl_lote": lote,    
      "dosificacion": dosificacion,
      "cantidad": cantidadBolsone,      
    };
  }
}
