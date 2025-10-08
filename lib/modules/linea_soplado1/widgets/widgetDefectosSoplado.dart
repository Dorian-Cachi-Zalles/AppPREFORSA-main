import 'package:control_de_calidad/core/widgets/dropdownformulario.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetAtributosNCSoplado extends StatefulWidget {
  final List<String> defectosIdentificados; // variables
  final List<String> otros; // constantes
  final ValueChanged<Map<String, dynamic>> onSelected;
  final void Function(String criticidad, String atributoDeNC,
      String seccionDefecto, int cantidadDefectosMuestra)? onSelect1;
  final void Function(
    String atributoDeNC,
  )? onSelect2;

  /// Valores iniciales para persistencia
  final Map<String, dynamic>? initialValue;

  const WidgetAtributosNCSoplado({
    super.key,
    required this.defectosIdentificados,
    required this.otros,
    required this.onSelected,
    this.initialValue,
    this.onSelect1,
    this.onSelect2,
  });

  @override
  State<WidgetAtributosNCSoplado> createState() => _WidgetAtributosNCSopladoState();
}

class _WidgetAtributosNCSopladoState extends State<WidgetAtributosNCSoplado> {
  Map<String, dynamic>? _selected;
  Future<void> _showDialog() async {
    Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero, // Para usar todo el ancho
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85, // 85% del ancho
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Título con gradiente
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF5252), // rojo claro brillante
                        Color(0xFFD32F2F), // rojo fuerte e intenso
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Título principal
                      Text(
                        "Motivo de no conformidad",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Icono representativo
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      // Subtítulo
                      Text(
                        "Porque motivo está observando el producto. Existen dos opciones: los detectados en el muestreo u otros.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Botones lado a lado
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final sel = await _buildDefectoFormDialog(
                              title: "Defecto Identificado",
                              defectos: widget.defectosIdentificados,
                              initialValue: widget.initialValue,
                            );
                            if (sel != null) Navigator.pop(dialogContext, sel);
                          },
                          icon: const Icon(Icons.check_box_outlined,
                              color: Colors.black // verde oscuro
                              ),
                          label: Text(
                            "Detectados",
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final sel = await _buildOtrosFormDialog(
                              title: "Otros",
                              defectos: widget.otros,
                              initialValue: widget.initialValue,
                            );
                            if (sel != null) Navigator.pop(dialogContext, sel);
                          },
                          icon: const Icon(
                            Icons.list_alt,
                            color: Colors.black, // verde oscuro
                          ),
                          label: Text(
                            "Otros",
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side:
                                const BorderSide(color: Colors.black, width: 1),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() => _selected = result);
      widget.onSelected(result);
    }
  }

  /// Formulario completo (Defectos Identificados)
  Future<Map<String, dynamic>?> _buildDefectoFormDialog({
    required String title,
    required List<String> defectos,
    Map<String, dynamic>? initialValue,
  }) {
    final _formKey = GlobalKey<FormBuilderState>();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // 90% del ancho
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Título con fondo verde degradado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF5252), // rojo claro brillante
                        Color(0xFFD32F2F), // rojo fuerte e intenso
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                // 🔹 Contenido
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: initialValue ?? {},
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownSimpleLIST(
                            name: 'defecto',
                            label: 'Atributo Producto No Conforme',
                            textoError: 'Selecciona',
                            dropOptions: defectos,
                          ),
                          const CustomInputFieldPeque(
                            name: 'cantidadDefectosMuestra',
                            label: 'Cantidad de Defectos en la Muestra',
                            isNumeric: true,
                            isRequired: true,
                            isreadonly: false,
                          ),
                          const DropdownSimpleLIST(
                            name: 'seccionDefecto',
                            label: 'Ubicacion del Defecto en la caja',
                            textoError: 'Selecciona',
                            dropOptions: ['Al inicio', 'Medio', 'Final'],
                          ),
                          const DropdownSimpleLIST(
                            name: 'criticidad',
                            label: 'Criticidad',
                            textoError: 'Selecciona',
                            dropOptions: ['Alta', 'Media', 'Baja'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔹 Botones
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(
                            "Cancelar",
                            style: GoogleFonts.quicksand(
                              color: Colors.black, // verde oscuro
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              final valores = _formKey.currentState!.value;
                              Navigator.pop(dialogContext, valores);

                              if (widget.onSelect1 != null &&
                                  valores['criticidad'] != null &&
                                  valores['defecto'] != null &&
                                  valores['cantidadDefectosMuestra'] != null &&
                                  valores['seccionDefecto'] != null) {
                                widget.onSelect1!(
                                  valores['criticidad'] as String,
                                  valores['defecto'] as String,
                                  valores['seccionDefecto'] as String,
                                  int.tryParse(
                                          valores['cantidadDefectosMuestra']
                                              .toString()) ??
                                      0,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.black),
                          ),
                          child: Text(
                            "Aceptar",
                            style: GoogleFonts.quicksand(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Formulario simple (Otros)
  Future<Map<String, dynamic>?> _buildOtrosFormDialog({
    required String title,
    required List<String> defectos,
    Map<String, dynamic>? initialValue,
  }) {
    final _formKey = GlobalKey<FormBuilderState>();
    List<String> opciones = [...defectos];
    String? defectoInicial = initialValue?['defecto'];

    // Si el valor inicial no está en las opciones, agrégalo
    if (defectoInicial != null && !opciones.contains(defectoInicial)) {
      opciones.add(defectoInicial);
    }

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // 90% ancho
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 Título con fondo verde degradado
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF5252), // rojo claro brillante
                            Color(0xFFD32F2F), // rojo fuerte e intenso
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Motivo de No Conformidad",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            Icons.error_outline,
                            size: 36,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Porque motivo está observando el producto. Existen dos opciones: los detectados en el muestreo u otros.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔹 Contenido
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FormBuilder(
                        key: _formKey,
                        initialValue:
                            initialValue ?? {'defecto': defectoInicial},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownSimpleLIST(
                              name: 'defecto',
                              label: 'Atributo Producto No Conforme',
                              textoError: 'Selecciona',
                              dropOptions: opciones,
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black38,
                              ),
                              label: Text(
                                "Agregar nueva opción",
                                style: GoogleFonts.quicksand(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              onPressed: () async {
                                final controller = TextEditingController();
                                final nueva = await showDialog<String>(
                                  context: context,
                                  builder: (subDialogContext) {
                                    return AlertDialog(
                                      title: const Text("Nueva opción"),
                                      content: TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                          hintText: "Escribe aquí",
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(subDialogContext),
                                          child: Text(
                                            "Cancelar",
                                            style: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (controller.text
                                                .trim()
                                                .isNotEmpty) {
                                              Navigator.pop(subDialogContext,
                                                  controller.text.trim());
                                            }
                                          },
                                          child: Text(
                                            "Agregar",
                                            style: GoogleFonts.quicksand(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (nueva != null && nueva.isNotEmpty) {
                                  setStateDialog(() {
                                    opciones.add(nueva);
                                    defectoInicial = nueva;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 🔹 Botones lado a lado
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: Text(
                                "Cancelar",
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.saveAndValidate() ??
                                    false) {
                                  final valores = _formKey.currentState!.value;
                                  Navigator.pop(dialogContext, valores);
                                  if (widget.onSelect2 != null &&
                                      valores['defecto'] != null) {
                                    widget.onSelect2!(valores['defecto']);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.black),
                              ),
                              child: Text(
                                "Aceptar",
                                style: GoogleFonts.quicksand(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showDialog,
      child: Container(
        width: double.infinity, // ocupa todo el ancho disponible
        child: Card(
          color: Colors.white,
          shadowColor: Colors.blue.shade600,
          elevation: 3,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Presione para modificar",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                const Text(
                  "Atributo Producto No Conforme",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  () {
                    final Map<String, dynamic>? data =
                        _selected ?? widget.initialValue;

                    if (data == null) return "Seleccione...";

                    // Filtrar campos vacíos o que sean '0'
                    final filtered = data.entries.where((e) {
                      final value = e.value;

                      if (value == null) return false;

                      if (value is String) {
                        final trimmed = value.trim();
                        if (trimmed.isEmpty ||
                            trimmed == '0' ||
                            trimmed == '0.0') return false;
                      }

                      if (value is int && value == 0) return false;
                      if (value is double && value == 0.0) return false;

                      return true;
                    });

                    if (filtered.isEmpty) return "Seleccione...";

                    return filtered
                        .map((e) => "${e.key.toUpperCase()} : ${e.value}")
                        .join("\n");
                  }(),
                  style: TextStyle(
                    color: Colors.blueGrey.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
