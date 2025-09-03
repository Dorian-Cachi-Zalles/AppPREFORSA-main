import 'package:flutter/material.dart';

class EnviadoDialog extends StatelessWidget {
  final bool seEnvio;

  const EnviadoDialog({super.key, required this.seEnvio});

  static void mostrar(BuildContext context, bool seEnvio) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EnviadoDialog(seEnvio: seEnvio),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(seEnvio ? "images/check.gif" : "images/error.gif"),
          const SizedBox(height: 10),
          Text(
            seEnvio ? "ENVIADO" : "ERROR DE ENVÍO",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(seEnvio
              ? "Registros enviados correctamente"
              : "No se pudo enviar los registros"),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }
}
