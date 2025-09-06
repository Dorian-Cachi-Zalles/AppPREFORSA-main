import 'package:control_de_calidad/core/widgets/AlertaErrores.dart';
import 'package:control_de_calidad/core/widgets/AlertasAPI.dart';
import 'package:control_de_calidad/core/widgets/boton_guardar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BotonDeslizableGenerico<T extends ChangeNotifier, M>
    extends StatelessWidget {
  final Color colorcito;
  final int id;
  final bool Function(T provider, int id) obtenerHasError;
  final M Function({bool? hasSend}) obtenerDatos;
  final Future<void> Function(T provider, int id, M datos) onUpdate;
  final Future<bool> Function(T provider, int id) onEnviar;

  const BotonDeslizableGenerico({
    super.key,
    required this.colorcito,
    required this.id,
    required this.obtenerDatos,
    required this.onUpdate,
    required this.onEnviar,
    required this.obtenerHasError,
  });

  Future<void> _actualizar(T provider, {bool hasSend = false}) async {
    final updated = obtenerDatos(hasSend: hasSend);
    await onUpdate(provider, id, updated);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<T>(context, listen: false);

    return BotonDeslizable(
      colorcito: colorcito,
      onPressed: () async {
        await _actualizar(provider);
        if (!context.mounted) return;
        Navigator.pop(context);
      },
      onSwipedAction: () async {
        // Si no hay errores, ejecutar lógica normal
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
          await _actualizar(provider, hasSend: true);
          if (!context.mounted) return;
          EnviadoDialog.mostrar(context, true);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
        }
      },
    );
  }
}
