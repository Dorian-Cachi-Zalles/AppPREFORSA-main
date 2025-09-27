    
class ModeloDatosColoracapDefectos_3 {
  final int? id;
  final bool hasErrors;
  final bool hasSend;
  final int cod_dpcalidad;
  final String Hora;
  final int cod_producto;
  final bool D1;
  final bool D2;
  final bool D3;
  final bool D4;
  final bool D5;
  final bool D6;
  final bool D7;
  final bool D8;
  final bool D9;
  final bool D10;
  final bool isConcatenado;

  const ModeloDatosColoracapDefectos_3({
    this.id,
    required this.hasErrors,
    required this.hasSend,
    required this.cod_dpcalidad,
    required this.Hora,
    required this.cod_producto,
    required this.D1,
    required this.D2,
    required this.D3,
    required this.D4,
    required this.D5,
    required this.D6,
    required this.D7,
    required this.D8,
    required this.D9,
    required this.D10,
    required this.isConcatenado



  });

  factory ModeloDatosColoracapDefectos_3.fromMap(Map<String, dynamic> map) {
    return ModeloDatosColoracapDefectos_3(
      id: map['id'] as int?,
      hasErrors: map['hasErrors'] == 1,
      hasSend: map['hasSend'] == 1,
      cod_dpcalidad: map['cod_dpcalidad'] as int,
      Hora: map['Hora'] as String,
      cod_producto: map['cod_producto'] as int,
      D1: (map['D1'] as int) == 1,
      D2: (map['D2'] as int) == 1,
      D3: (map['D3'] as int) == 1,
      D4: (map['D4'] as int) == 1,
      D5: (map['D5'] as int) == 1,
      D6: (map['D6'] as int) == 1,
      D7: (map['D7'] as int) == 1,
      D8: (map['D8'] as int) == 1,
      D9: (map['D9'] as int) == 1,
      D10: (map['D10'] as int) == 1,
      isConcatenado: (map['isConcatenado'] as int) == 1,
    );
  }

   ModeloDatosColoracapDefectos_3 copyWithForm(Map<String, dynamic> formValues, {bool? hasSend, bool? hasErrors}) {
    return ModeloDatosColoracapDefectos_3(
      id: id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad,
      Hora: Hora,
    cod_producto:cod_producto,
    D1: (formValues['D1'] ?? D1),
    D2: (formValues['D2'] ?? D2),
    D3: (formValues['D3'] ?? D3),
    D4: (formValues['D4'] ?? D4),
    D5: (formValues['D5'] ?? D5),
    D6: (formValues['D6'] ?? D6),
    D7: (formValues['D7'] ?? D7),
    D8: (formValues['D8'] ?? D8),
    D9: (formValues['D9'] ?? D9),
    D10: (formValues['D10'] ?? D10),
    isConcatenado: isConcatenado,
    );
  }
 
  
 
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'hasErrors': hasErrors ? 1 : 0,
      'hasSend': hasSend ? 1 : 0,
      'cod_dpcalidad': cod_dpcalidad,
      'Hora': Hora,
      'cod_producto': cod_producto,
      'D1': D1 ? 1 : 0,
      'D2': D2 ? 1 : 0,
      'D3': D3 ? 1 : 0,
      'D4': D4 ? 1 : 0,
      'D5': D5 ? 1 : 0,
      'D6': D6 ? 1 : 0,
      'D7': D7 ? 1 : 0,
      'D8': D8 ? 1 : 0,
      'D9': D9 ? 1 : 0,
      'D10': D10 ? 1 : 0,
      'isConcatenado':isConcatenado? 1:0


    };
  }

  ModeloDatosColoracapDefectos_3 copyWith({
    int? id,
    bool? hasErrors,
    bool? hasSend,
    int? cod_dpcalidad,
    String? Hora, int? cod_producto, bool? D1, bool? D2, bool? D3, bool? D4, bool? D5, bool? D6, bool? D7, bool? D8, bool? D9, bool? D10,
    bool? isConcatenado,
  }) {
    return ModeloDatosColoracapDefectos_3(
      id: id ?? this.id,
      hasErrors: hasErrors ?? this.hasErrors,
      hasSend: hasSend ?? this.hasSend,
      cod_dpcalidad: cod_dpcalidad ?? this.cod_dpcalidad,
      Hora: Hora ?? this.Hora,
      cod_producto: cod_producto ?? this.cod_producto,
      D1: D1 ?? this.D1,
      D2: D2 ?? this.D2,
      D3: D3 ?? this.D3,
      D4: D4 ?? this.D4,
      D5: D5 ?? this.D5,
      D6: D6 ?? this.D6,
      D7: D7 ?? this.D7,
      D8: D8 ?? this.D8,
      D9: D9 ?? this.D9,
      D10: D10 ?? this.D10,
      isConcatenado: isConcatenado?? this.isConcatenado
    );
  }
}


extension ModeloDatosColoracapDefectos_3Api on ModeloDatosColoracapDefectos_3 {
  Map<String, dynamic> toJsonAPI() {
    return {
      "cod_dpcalidad": cod_dpcalidad,
      "Hora": Hora,
      "cod_producto": cod_producto,
      "D1": D1,
      "D2": D2,
      "D3": D3,
      "D4": D4,
      "D5": D5,
      "D6": D6,
      "D7": D7,
      "D8": D8,
      "D9": D9,
      "D10": D10
    };
  }
}
