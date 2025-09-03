import 'package:control_de_calidad/core/widgets/AlertaErrores.dart';
import 'package:control_de_calidad/core/widgets/AlertasAPI.dart';
import 'package:control_de_calidad/core/widgets/boton_guardar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BotonDeslizableConId<T extends ChangeNotifier, M, N>
    extends StatelessWidget {
  final Color colorcito;
  final int id;
  final bool condicional;
  final bool Function(T provider, int id) obtenerHasError1;
  final bool Function(T provider, int id) obtenerHasError2;
  final M Function({bool? hasSend}) obtenerDatosPrimario;
  final Future<N> Function({int? idregistro}) obtenerDatosSecundario;
  final Future<void> Function(T provider, int id, M datos) onUpdatePrimario;
  final Future<void> Function(T provider, int id, N datos) onUpdateSecundario;
  final Future<int> Function(T provider, int id) onEnviarPrimario;
  final Future<bool> Function(T provider, int id) onEnviarSecundario;

  const BotonDeslizableConId({
    super.key,
    required this.colorcito,
    required this.id,
    required this.obtenerDatosPrimario,
    required this.obtenerDatosSecundario,
    required this.onUpdatePrimario,
    required this.onUpdateSecundario,
    required this.onEnviarPrimario,
    required this.onEnviarSecundario,
    required this.condicional,
    required this.obtenerHasError1,
    required this.obtenerHasError2,
  });

  Future<void> _actualizarPrimario(T provider, {bool hasSend = false}) async {
    final updated = obtenerDatosPrimario(hasSend: hasSend);
    print("📤 Actualizando PRIMARIO (hasSend=$hasSend): $updated");
    await onUpdatePrimario(provider, id, updated);
  }

  Future<void> _actualizarSecundario(T provider, {int idregistro = 0}) async {
    final updated =
        await obtenerDatosSecundario(idregistro: idregistro); // await aquí
    await onUpdateSecundario(provider, id, updated);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<T>(context, listen: false);

    return BotonDeslizable(
      colorcito: colorcito,
      onPressed: () async {
        print("🟡 [onPressed] Solo actualizando localmente");
        await _actualizarPrimario(provider);
        await _actualizarSecundario(provider);
        if (!context.mounted) return;
        Navigator.pop(context);
      },
      onSwipedAction: () async {
        await _actualizarPrimario(provider);
        await _actualizarSecundario(provider);
        if (!context.mounted) return;
        final hasErrorActual1 = obtenerHasError1(provider, id);
        final hasErrorActual2 = obtenerHasError2(provider, id);
        if (hasErrorActual1 == true) {
          // Mostrar mensaje de error si hay errores
          if (!context.mounted) return;
          EnviadoDialogErrores.mostrar(context);

          return; // Salimos sin ejecutar la acción
        }
        if (!condicional) {
          final idGenerado = await onEnviarPrimario(provider, id);
          if (!context.mounted) return;
          if (idGenerado < 0) {
            print("❌ Error: No se generó un ID válido");
            EnviadoDialog.mostrar(context, false);
            return;
          }
          await _actualizarPrimario(provider, hasSend: true);
          EnviadoDialog.mostrar(context, true);
          print("Hasta aqui si solo es defecto");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.pop(context);
          });
          return;
        } else {
          if (hasErrorActual2 == true) {
            // Mostrar mensaje de error si hay errores
            if (!context.mounted) return;
            EnviadoDialogErrores.mostrar(context);
            return; // Salimos sin ejecutar la acción
          }
          final enviadoSecundario = await onEnviarSecundario(provider, id);
          if (!context.mounted) return;
          if (enviadoSecundario) {
            await _actualizarPrimario(provider, hasSend: true);
            if (!context.mounted) return;
            EnviadoDialog.mostrar(context, true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) Navigator.pop(context);
            });
          } else {
            EnviadoDialog.mostrar(context, false);
          }
        }
      },
    );
  }
}
