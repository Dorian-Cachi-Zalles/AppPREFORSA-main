import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/core/widgets/dropdownformulario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class FlotanteActualizarEstados extends StatefulWidget {
  final String id;
  final String apiUrl; // URL del endpoint PUT
  final List<String> valoresIniciales;

  const FlotanteActualizarEstados({
    super.key,
    required this.id,
    required this.apiUrl,
    required this.valoresIniciales,
  });

  @override
  State<FlotanteActualizarEstados> createState() =>
      _FlotanteActualizarEstadosState();
}

class _FlotanteActualizarEstadosState extends State<FlotanteActualizarEstados> {
  String? estadoDelProducto;
  String? estadoDelProductoC;
  String? estadoDelProductoNC;
  bool cargando = false;

  Future<void> actualizar() async {
    setState(() => cargando = true);

    final payload = {
      "estadoDelProducto": estadoDelProducto,
      "estadoDelProductoC": estadoDelProductoC,
      "estadoDelProductoNC": estadoDelProductoNC,
    };

    // Debug: ver qué estamos enviando
    print("Enviando payload al PUT: ${json.encode(payload)}");
    print("URL: ${widget.apiUrl}");

    try {
      final response = await http.put(
        Uri.parse(widget.apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(payload),
      );

      setState(() => cargando = false);

      print("Código de respuesta: ${response.statusCode}");
      print("Cuerpo de respuesta: ${response.body}");

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // cerramos la ventana flotante
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Actualización exitosa')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error al actualizar: ${response.statusCode} ${response.body}')));
      }
    } catch (e) {
      setState(() => cargando = false);
      print("Error al hacer PUT: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al hacer PUT: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogosProvider = Provider.of<CatalogosProvider>(context);
    final Map<String, List<dynamic>> dropOptionsDatosDEFIPS =
        catalogosProvider.getCatalogo('Observados');
    return AlertDialog(
      title: const Text('Actualizar Estados del Producto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownSimple(
              name: 'estadoDelProducto',
              label: 'Estado del Producto',
              textoError: 'Selecciona',
              valorInicial: widget.valoresIniciales[0],
              opciones: 'EstadoProducto',
              dropOptions: dropOptionsDatosDEFIPS,
              onChanged: (v) => setState(() => estadoDelProducto = v),
            ),
            DropdownSimple(
              name: 'estadodelProductoC',
              label: 'Estado Producto Conforme',
              textoError: 'Selecciona',
              valorInicial: widget.valoresIniciales[1],
              opciones: 'EstadoProductoC',
              dropOptions: dropOptionsDatosDEFIPS,
              onChanged: (v) => setState(() => estadoDelProductoC = v),
            ),
            DropdownSimple(
              name: 'estadodelProductoNC',
              label: 'Estado Producto No Conforme',
              textoError: 'Selecciona',
              valorInicial: widget.valoresIniciales[2],
              opciones: 'EstadoProductoNC',
              dropOptions: dropOptionsDatosDEFIPS,
              onChanged: (v) => setState(() => estadoDelProductoNC = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: cargando ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: cargando ? null : actualizar,
          child: cargando
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Actualizar'),
        ),
      ],
    );
  }
}
