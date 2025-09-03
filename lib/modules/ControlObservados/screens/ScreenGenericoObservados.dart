import 'package:control_de_calidad/modules/ControlObservados/Models/modelogenerico.dart';
import 'package:control_de_calidad/modules/ControlObservados/providers/providerObservados.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FlipCardWidget extends StatefulWidget {
  final String apiUrl;
  final ModeloAPIGenerico Observados;
  final Map<String, dynamic> postPayload; // JSON a enviar
  final String? campoChip; // ahora opcional, se puede ignorar
  final Map<String, Color>? chipColors;
  final int chunkSize;
  final Widget Function(String id, List<String>)? dialogBuilder;

  const FlipCardWidget({
    super.key,
    required this.Observados,
    this.campoChip,
    this.chipColors,
    this.chunkSize = 5,
    this.dialogBuilder,
    required this.apiUrl,
    required this.postPayload,
  });

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> {
  int currentPage = 0;

  String formatKey(String key) {
    // Inserta un espacio antes de cada mayúscula (excepto la primera letra)
    final withSpaces = key.replaceAllMapped(
        RegExp(r'(?<=[a-z])([A-Z])'), (match) => ' ${match.group(0)}');
    return withSpaces.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrar campos si queremos ocultar campoChip
    final List<MapEntry<String, dynamic>> campos =
        widget.Observados.campos.entries
            .where((e) => e.key != widget.campoChip) // oculta el chip
            .where((e) => e.key != widget.campoChip && e.key != 'o_id')
            .toList();

    // Partir en chunks
    List<List<MapEntry<String, dynamic>>> chunks = [];
    for (var i = 0; i < campos.length; i += widget.chunkSize) {
      chunks.add(campos.sublist(
          i,
          i + widget.chunkSize > campos.length
              ? campos.length
              : i + widget.chunkSize));
    }

    // Chip dinámico (opcional, puedes comentar para ocultar)
    Widget? chip;
    if (widget.campoChip != null &&
        widget.Observados[widget.campoChip!] != null) {
      final label = widget.Observados[widget.campoChip!].toString();
      Color backgroundColor = widget.chipColors?[label] ?? Colors.grey[800]!;
      chip = Chip(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
      );
    }

    return GestureDetector(
      onTap: () {
        final id = widget.Observados.campos['o_id'];
        final String? EP =
            widget.Observados.campos['estadoDelProducto']?.toString();
        final String? EPC =
            widget.Observados.campos['estadodelProductoC']?.toString();
        final String? EPNC =
            widget.Observados.campos['estadodelProductoNC']?.toString();
        final List<String> valoresIniciales = [EP ?? '', EPC ?? '', EPNC ?? ''];

        if (widget.dialogBuilder != null) {
          showDialog(
            context: context,
            builder: (_) =>
                widget.dialogBuilder!(id.toString(), valoresIniciales),
          ).then((actualizado) {
            // Cuando se cierra el diálogo, recargamos la UI
            final provider =
                Provider.of<ProviderObservados>(context, listen: false);
            provider.fetchDatos(
                widget.apiUrl, widget.postPayload); // recarga lista
          });
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12), // solo horizontal
          decoration: const BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // se ajusta al contenido
            children: [
              if (chip != null)
                Row(
                  children: [
                    Text(
                      formatKey(widget.campoChip!),
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    Align(alignment: Alignment.centerRight, child: chip),
                  ],
                ),

              // PageView para chunks
              SizedBox(
                height: 140, // menor altura
                child: PageView.builder(
                  onPageChanged: (index) => setState(() => currentPage = index),
                  itemCount: chunks.length,
                  itemBuilder: (context, index) {
                    final chunk = chunks[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: chunk.map((entry) {
                        final key = entry.key;
                        final value = entry.value;
                        String displayValue;

                        if (value is bool)
                          displayValue = value ? "Sí" : "No";
                        else if (value is num)
                          displayValue = value.toString();
                        else if (value is String &&
                            key.toLowerCase().contains('fecha')) {
                          try {
                            displayValue = DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(value));
                          } catch (_) {
                            displayValue = value;
                          }
                        } else
                          displayValue = value?.toString() ?? '';

                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: '${formatKey(key)}: ',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(text: displayValue),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              // Indicador de páginas
              if (chunks.length > 1)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        chunks.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == currentPage
                                ? Colors.blue
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ObservadosScreen extends StatelessWidget {
  final String apiUrl;
  final Map<String, dynamic> postPayload; // JSON a enviar
  final String? campoChip;
  final Map<String, Color>? chipColors;
  final List<String> dropdownitems;
  final Widget Function(String id, List<String>)? dialogBuilder;

  const ObservadosScreen({
    super.key,
    required this.apiUrl,
    required this.postPayload,
    this.campoChip,
    this.chipColors,
    required this.dropdownitems,
    this.dialogBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProviderObservados()..fetchDatos(apiUrl, postPayload),
      child: Scaffold(
        body: Consumer<ProviderObservados>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // Filtro de texto
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Buscar por cualquier campo'),
                    onChanged: provider.actualizarFiltroTexto,
                  ),
                ),

                // Dropdown con valores predeterminados
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: DropdownButton<String>(
                    value: provider.filtroDropdown, // usar getter del provider
                    hint: const Text("Filtrar por valor predeterminado"),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text("Todos"), // opción para quitar filtro
                      ),
                      ...dropdownitems // tus valores predeterminados
                          .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)))
                          .toList(),
                    ],
                    onChanged: provider.actualizarFiltroDropdown,
                  ),
                ),

                // Lista de cards
                Expanded(
                  child: provider.paginados.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: provider.paginados.length,
                          itemBuilder: (context, index) => FlipCardWidget(
                            apiUrl: apiUrl,
                            postPayload: postPayload,
                            Observados: provider.paginados[index],
                            campoChip: campoChip,
                            chipColors: chipColors,
                            dialogBuilder: dialogBuilder,
                          ),
                        ),
                ),

                // Paginación
                if (provider.totalPaginas > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: provider.paginaActual > 0
                              ? provider.paginaAnterior
                              : null,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        Text(
                            "Página ${provider.paginaActual + 1} de ${provider.totalPaginas}"),
                        IconButton(
                          onPressed:
                              provider.paginaActual < provider.totalPaginas - 1
                                  ? provider.paginaSiguiente
                                  : null,
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
