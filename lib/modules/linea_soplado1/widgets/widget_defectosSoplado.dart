import 'package:control_de_calidad/core/constants/catalogodropdowns.dart';
import 'package:control_de_calidad/modules/linea_I6/screens/screen_defectos.dart';
import 'package:control_de_calidad/modules/linea_soplado1/providers/DatosProviderSoplado1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefectosScreenWidgetSoplado1 extends StatefulWidget {
  final int id;
  const DefectosScreenWidgetSoplado1({required this.id, Key? key}) : super(key: key);

  @override
  _DefectosScreenState createState() => _DefectosScreenState();
}

class _DefectosScreenState extends State<DefectosScreenWidgetSoplado1> {
  final TextEditingController _searchController = TextEditingController();
  List<String> defectosOptions = [
    'PC',
    'MM',
    'CB'
    
  ];
  List<String> criticidadOptions = ['A', 'M', 'B'];
  String? selectedCriticidad;

  Map<String, Map<String, String>> defectosImages = {
    'PC': {
      'name': 'Punto Contaminantes',
      'image': 'images/d3.png',
    },
    'MM': {
      'name': 'Marca de molde',
      'image': 'images/nohayfoto.avif',
    } 

  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final datosProvider = Provider.of<ProviderSoplado1>(context);
    final ProviderOpciones = Provider.of<EditProviderDatosDEFIPS>(context);
    final catalogosProvider = Provider.of<CatalogosProvider>(context);

    final Map<String, List<dynamic>> dropOptionsDatosDEFIPS =
        catalogosProvider.getCatalogo('defectos');
    final List<String> opcionesnormales =
        List<String>.from(dropOptionsDatosDEFIPS['NCAtributo'] ?? []);

    final dato = datosProvider.RepoDefectos.items.firstWhere(
      (dato) => dato.id == widget.id,
    );

    // Filtrar por el nombre dentro del mapa
    final filteredDefectos = defectosImages.entries.where((entry) {
      final name = entry.value['name']?.toLowerCase() ?? '';
      return name.contains(_searchController.text.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buscador de defectos
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Buscar defecto',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),

          const SizedBox(height: 10),

          // Mostrar los códigos (ej. 'PC') en los Wraps
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: filteredDefectos.map((entry) {
              final codigo = entry.key;
              final isSelected = dato.defectos.contains(codigo);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      dato.defectos.remove(codigo);
                    } else {
                      dato.defectos.add(codigo);
                    }
                  });
                  datosProvider.updateDefectos(
                    dato.id!,
                    dato.copyWith(defectos: dato.defectos),
                  );
                  ProviderOpciones.actualizarOpciones(
                      opcionesnormales, dato.defectos);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange[300] : Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    codigo, // 👈 Aquí se muestra la abreviatura
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
