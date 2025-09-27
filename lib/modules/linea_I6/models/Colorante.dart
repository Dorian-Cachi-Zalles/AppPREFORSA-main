class ModeloColorante {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String colorante;
  final String codigo;
  final String kl;
  final String bp;
  final double dosificacion;
  final int cantidadBolsone;

  const ModeloColorante(
      {this.id,
      required this.hasErrors,
      required this.hasSend,
      required this.cod_dpcalidad,
      required this.colorante,
      required this.codigo,
      required this.kl,
      required this.bp,
      required this.dosificacion,
      required this.cantidadBolsone});

  factory ModeloColorante.fromMap(Map<String, dynamic> map) {
    return ModeloColorante(
        id: map['id'] as int?,
        hasErrors: map['hasErrors'] == 1,
        hasSend: map['hasSend'] == 1,
        cod_dpcalidad: map['cod_dpcalidad'] as int,
        colorante: map['colorante'] as String,
        codigo: map['codigo'] as String,
        kl: map['kl'] as String,
        bp: map['bp'] as String,
        dosificacion: map['dosificacion'] as double,
        cantidadBolsone: map['cantidadBolsone'] as int);
  }

  ModeloColorante copyWithForm(Map<String, dynamic> formValues,
      {bool? hasSend, bool? hasErrors}) {
    return ModeloColorante(
        id: id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad,
        colorante: _toString(formValues['colorante']),
        codigo: _toString(formValues['codigo']),
        kl: _toString(formValues['kl']),
        bp: _toString(formValues['bp']),
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
      'kl': kl,
      'bp': bp,
      'dosificacion': dosificacion,
      'cantidadBolsone': cantidadBolsone
    };
  }

  ModeloColorante copyWith(
      {int? id,
      bool? hasErrors,
      bool? hasSend,
      int? cod_dpcalidad,
      String? colorante,
      String? codigo,
      String? kl,
      String? bp,
      double? dosificacion,
      int? cantidadBolsone}) {
    return ModeloColorante(
        id: id ?? this.id,
        hasErrors: hasErrors ?? this.hasErrors,
        hasSend: hasSend ?? this.hasSend,
        cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
        colorante: colorante ?? this.colorante,
        codigo: codigo ?? this.codigo,
        kl: kl ?? this.kl,
        bp: bp ?? this.bp,
        dosificacion: dosificacion ?? this.dosificacion,
        cantidadBolsone: cantidadBolsone ?? this.cantidadBolsone);
  }
}

extension ModeloColoranteApi on ModeloColorante {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "colorante": colorante,
      "codigo": codigo,
      "kl_lote": kl,
      "bp": bp,
      "dosificacion": dosificacion,
      "cantidad": cantidadBolsone,      
    };
  }
}
