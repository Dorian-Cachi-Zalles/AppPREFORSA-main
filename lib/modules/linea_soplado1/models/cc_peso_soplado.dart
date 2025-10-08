    
class Modelo_peso_soplado {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String hora;
  final int cod_producto;
  final List<String> cavidad;
  final List<double> Zsup;
  final List<double> Zmed;
  final List<double> Zinf;
  final bool isConcatenado;

  const Modelo_peso_soplado({
    this.id,
    required this.hasErrors,
    required this.hasSend,
    required this.cod_dpcalidad,
    required this.hora,
    required this.cod_producto,
    required this.cavidad,
    required this.Zsup,
    required this.Zmed,
    required this.Zinf,
    required this.isConcatenado,
  });

  factory Modelo_peso_soplado.fromMap(Map<String, dynamic> map) {
    return Modelo_peso_soplado(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
      cod_dpcalidad: map['cod_dpcalidad'] as int,
      hora: map['hora'] as String,
      cod_producto: map['cod_producto'] as int,
      cavidad: (map['cavidad'] as String)
            .split(',')
            .where((item) => item.isNotEmpty)
            .toList(),
      Zsup: (map['Zsup'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList(),
      Zmed: (map['Zmed'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList(),
      Zinf: (map['Zinf'] as String).split(',').where((item) => item.isNotEmpty).map(double.parse).toList(),
      isConcatenado: (map['isConcatenado'] as int) == 1,
    );
  }

   Modelo_peso_soplado copyWithForm(Map<String, dynamic> formValues, {bool? hasSend, 
   bool? hasErrors, List<double>? Zsup,List<double>? Zmed,List<double>? Zinf, }) {
    return Modelo_peso_soplado(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      hora: _toString(formValues['hora']),
    cod_producto: _toInt(formValues['cod_producto']),
    cavidad: cavidad,
    Zsup: Zsup?? this.Zsup,
    Zmed: Zmed ?? this.Zmed,
    Zinf: Zinf ?? this.Zinf,
    isConcatenado: isConcatenado,
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
      'hora': hora,
      'cod_producto': cod_producto,
      'cavidad': cavidad.join(','),
      'Zsup': Zsup.join(','),
      'Zmed': Zmed.join(','),
      'Zinf': Zinf.join(','),
      'isConcatenado': isConcatenado ? 1 : 0,
    };
  }

  Modelo_peso_soplado copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,
     bool? isConcatenado,    
    String? hora, int? cod_producto, List<String>? cavidad, List<double>? Zsup, List<double>? Zmed, List<double>? Zinf
  }) {
    return Modelo_peso_soplado(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
      hora: hora ?? this.hora,
      cod_producto: cod_producto ?? this.cod_producto,
      cavidad: cavidad ?? this.cavidad,
      Zsup: Zsup ?? this.Zsup,
      Zmed: Zmed ?? this.Zmed,
      isConcatenado: isConcatenado ?? this.isConcatenado,
      Zinf: Zinf ?? this.Zinf
    );
  }
}


extension Modelo_peso_sopladoApi on Modelo_peso_soplado {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "hora": hora,
      "cod_producto": cod_producto,
      "cavidad": cavidad,
      "Zsup": Zsup,
      "Zmed": Zmed,
      "Zinf": Zinf
    };
  }
}
