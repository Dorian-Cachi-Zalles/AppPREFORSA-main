import 'package:flutter/material.dart';

class EnviadoDialogErrores extends StatelessWidget {
  const EnviadoDialogErrores({super.key});

  static void mostrar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const EnviadoDialogErrores(),
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
          Image.asset("images/lupa.gif"),
          const SizedBox(height: 10),
          const Text(
            "TIENES ERRORES EN EL FORMULARIO ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text("Corrije para enviar"),
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
