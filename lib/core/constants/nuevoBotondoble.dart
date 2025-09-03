import 'package:control_de_calidad/core/widgets/AlertaErrores.dart';
import 'package:control_de_calidad/core/widgets/AlertasAPI.dart';
import 'package:control_de_calidad/core/widgets/boton_guardar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BotonDeslizableConId2<T extends ChangeNotifier, M>
    extends StatelessWidget {
  final Color colorcito;
  final int id;
  final bool condicional;
  final bool Function(T provider, int id) obtenerHasError;
  final M Function({bool? hasSend}) obtenerDatos;
  final Future<void> Function(T provider, int id, M datos) onUpdate;
  final Future<bool> Function(T provider, int id) onEnviar;

  const BotonDeslizableConId2({
    super.key,
    required this.colorcito,
    required this.id,
    required this.obtenerDatos,
    required this.onUpdate,
    required this.onEnviar,
    required this.condicional,
    required this.obtenerHasError,
  });

  Future<void> _actualizar(T provider, {bool hasSend = false}) async {
    final updated = obtenerDatos(hasSend: hasSend);
    print("📤 Actualizando LOCAL (hasSend=$hasSend): $updated");
    await onUpdate(provider, id, updated);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<T>(context, listen: false);

    return BotonDeslizable(
      colorcito: colorcito,
      onPressed: () async {
        print("🟡 [onPressed] Guardando solo local");
        await _actualizar(provider);
        if (!context.mounted) return;
        Navigator.pop(context);
      },
      onSwipedAction: () async {
        print("🟢 [onSwipedAction] Enviando al servidor...");

        // 1️⃣ Actualizar local
        await _actualizar(provider);

        // 2️⃣ Verificar errores
        final hasErrorActual = obtenerHasError(provider, id);
        if (hasErrorActual && condicional) {
          print("❌ Hay errores, no se envía");
          if (!context.mounted) return;
          EnviadoDialogErrores.mostrar(context);
          return;
        }

        // 3️⃣ Enviar datos
        final enviado = await onEnviar(provider, id);
        print("📡 Respuesta servidor: $enviado");

        if (!context.mounted) return;
        if (enviado) {
          print("✅ Envío correcto, marcando como hasSend=true");
          await _actualizar(provider, hasSend: true);
          if (!context.mounted) return;
          EnviadoDialog.mostrar(context, true);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.pop(context);
          });
        } else {
          print("⚠️ Falló el envío");
          EnviadoDialog.mostrar(context, false);
        }
      },
    );
  }
}
