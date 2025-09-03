import 'package:control_de_calidad/core/widgets/grafica_de_linea.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraficoConProviderWidget extends StatelessWidget {
  final String apiUrl;
  final String campoX;
  final Map<String, VariableConfig> variables;

  const GraficoConProviderWidget({
    super.key,
    required this.apiUrl,
    required this.campoX,
    required this.variables,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = DatosGenericosProvider(
          apiUrl: apiUrl,
          campoX: campoX,
          variables: variables,
        );
        provider.fetchDatos();
        return provider;
      },
      child: Consumer<DatosGenericosProvider>(
        builder: (context, provider, _) {
          return GraficoLineasDinamico(provider: provider);
        },
      ),
    );
  }
}
