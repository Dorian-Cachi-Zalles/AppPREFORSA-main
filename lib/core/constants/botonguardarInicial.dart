import 'package:control_de_calidad/core/widgets/AlertaErrores.dart';
import 'package:control_de_calidad/core/widgets/AlertasAPI.dart';
import 'package:control_de_calidad/core/widgets/boton_agregar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BotonDeslizableGenericoInicial<T extends ChangeNotifier, M>
    extends StatelessWidget {
  final IconData? iconoopcional;
  final String? textoopcional;
  final Color colorcito;
  final bool Function(T provider, int id) obtenerHasError;
  final int id;
  final M Function() obtenerDatos;
  final Future<void> Function(T provider, int id, M datos) onUpdate;
  final Future<bool> Function(T provider, int id) onEnviar;

  const BotonDeslizableGenericoInicial({
    super.key,
    required this.colorcito,
    required this.id,
    required this.obtenerDatos,
    required this.onUpdate,
    required this.onEnviar,
    this.iconoopcional,
    this.textoopcional,
    required this.obtenerHasError,
  });

  Future<void> _actualizar(T provider) async {
    final updated = obtenerDatos();
    await onUpdate(provider, id, updated);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<T>(context, listen: false);

    return BotonAgregar(
      iconoopcional: iconoopcional,
      textoopcional: textoopcional,
      colorcito: colorcito,
      onPressed: () async {
        await _actualizar(provider);
        if (!context.mounted) return;

        final hasErrorActual = obtenerHasError(provider, id);

        if (hasErrorActual == true) {
          // Mostrar mensaje de error si hay errores
          if (!context.mounted) return;

          EnviadoDialogErrores.mostrar(context);

          return; // Salimos sin ejecutar la acción
        }

        final enviado = await onEnviar(provider, id);
        if (!context.mounted) return;

        if (!enviado) {
          EnviadoDialog.mostrar(context, false);
        } else {
          await _actualizar(provider);
          if (!context.mounted) return;
          EnviadoDialog.mostrar(context, true);
        }
      },
    );
  }
}
