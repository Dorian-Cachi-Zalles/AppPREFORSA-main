import 'dart:async';
import 'package:control_de_calidad/core/widgets/dropdownformulario.dart';
import 'package:control_de_calidad/core/widgets/textsimpleform.dart';
import 'package:control_de_calidad/modules/linea_I6/models/Observados.dart';
import 'package:control_de_calidad/modules/linea_I9/providers/DatosProviderPrefI9.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class FormularioGeneralDatosProduccionObervadaI9 extends StatefulWidget {
  const FormularioGeneralDatosProduccionObervadaI9({
    super.key,
    required GlobalKey<FormBuilderState> formKey,
    required this.widget,
    required this.dropOptions,
  }) : _formKey = formKey;

  final GlobalKey<FormBuilderState> _formKey;
  final ModeloObservados widget;
  final Map<String, List<dynamic>> dropOptions;

  @override
  State<FormularioGeneralDatosProduccionObervadaI9> createState() =>
      _FormularioGeneralDatosProduccionObervadaI9State();
}

class _FormularioGeneralDatosProduccionObervadaI9State
    extends State<FormularioGeneralDatosProduccionObervadaI9> {
  bool _yaValido = false; // 👈 para validar solo una vez
  @override
  Widget build(BuildContext context) {
    // 👇 Validar automáticamente en el primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_yaValido &&
          widget._formKey.currentState != null &&
          widget._formKey.currentState!.fields.isNotEmpty) {
        for (final field in widget._formKey.currentState!.fields.values) {
          field.validate(); // 🔹 muestra errores en rojo
        }
        _yaValido = true;
        setState(() {}); // 🔹 fuerza reconstrucción para pintar los errores
      }
    });
    void _guardarAuto(ModeloObservados datos) {
      final formState = widget._formKey.currentState;
      if (formState != null) {
        formState.save();
        final hasErrors = widget._formKey.currentState?.fields.values
                .any((field) => field.hasError) ??
            false;
        final values = formState.value;
        final updatedDatos = datos.copyWithForm(values, hasErrors: hasErrors);
        final provider = context.read<ProviderI9>();
        provider.updateObservados(datos.id!, updatedDatos);
      }
    }

    Timer? _debounce;
    void _guardarAutoDebounce(ModeloObservados datos) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        _guardarAuto(datos);
      });
    }

    return FormBuilder(
      key: widget._formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(children: [
        DropdownSimple(
          name: 'desvio',
          label: 'Desvio',
          textoError: 'Selecciona',
          valorInicial: widget.widget.desvio,
          opciones: 'Desvio',
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
        CustomInputField(
          name: 'cantidadRetenidaPorEmpaque',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Cantidad de Cajas Retenidas',
          isRequired: true,
          isNumeric: true,
          valorInicial: widget.widget.cantidadRetenidaPorEmpaque == 0
              ? ''
              : widget.widget.cantidadRetenidaPorEmpaque.toString(),
        ),
        DropdownSimple(
          name: 'estadoProducto',
          label: 'Estado del Producto',
          textoError: 'Selecciona',
          valorInicial: widget.widget.estadoProducto,
          opciones: 'EstadoProducto',
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
        DropdownSimple(
          name: 'etiquetaCalidad',
          label: 'Etiqueta',
          textoError: 'Selecciona',
          valorInicial: widget.widget.etiquetaCalidad,
          opciones: 'Etiqueta',
          isrequerid: true,
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
        DropdownSimple(
          name: 'aparicionDefecto',
          label: 'Arranque/Linea/Pucho',
          textoError: 'Selecciona',
          valorInicial: widget.widget.aparicionDefecto,
          opciones: 'ArranqueLinea',
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
        CustomInputField(
          name: 'reprocesoNoConformePzas',
          onChanged: (value) {
            _guardarAutoDebounce(widget.widget);
          },
          label: 'Reproceso No Conforme [PZAS]',
          isRequired: true,
          isNumeric: true,
          valorInicial: widget.widget.reprocesoNoConformePzas.toString(),
        ),
        DropdownSimple(
          name: 'estadoProductoConforme',
          label: 'Estado Producto Conforme',
          textoError: 'Selecciona',
          valorInicial: widget.widget.estadoProductoConforme,
          opciones: 'EstadoProductoC',
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
        DropdownSimple(
          name: 'estadoProductoNoConforme',
          label: 'Estado Producto No Conforme',
          textoError: 'Selecciona',
          valorInicial: widget.widget.estadoProductoNoConforme,
          opciones: 'EstadoProductoNC',
          dropOptions: widget.dropOptions,
          onChanged: (value) {
            _guardarAuto(widget.widget);
          },
        ),
      ]),
    );
  }
}
