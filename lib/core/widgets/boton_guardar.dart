import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_action/slide_action.dart';

class BotonDeslizable extends StatefulWidget {
  final VoidCallback? onPressed;
  final Function onSwipedAction;
  final Color colorcito;

  const BotonDeslizable({
    Key? key,
    this.onPressed,
    required this.onSwipedAction,
    required this.colorcito,
  }) : super(key: key);

  @override
  _BotonDeslizableState createState() => _BotonDeslizableState();
}

class _BotonDeslizableState extends State<BotonDeslizable> {
  bool isSliding = false;

  void _handlePress() {
    setState(() {
      isSliding = false;
    });
    // widget.onPressed!(); // Llamada a la acción de clic (guardar)
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: _handlePress,
        child: SlideAction(
          actionSnapThreshold:
              0.85, // Aumentado para hacer el movimiento más rápido
          trackBuilder: (context, state) {
            return Container(
              height: 80, // Reducido a la mitad
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                    Colors.black.withOpacity(0.24), widget.colorcito),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save,
                      color: Colors.black, size: 30), // Icono añadido
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "deslize para",
                        style: GoogleFonts.quicksand(
                          fontSize: 10, // Ajuste del tamaño del texto
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "MANDAR REGISTRO",
                        style: GoogleFonts.quicksand(
                          fontSize: 20, // Ajuste del tamaño del texto
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          thumbBuilder: (context, state) {
            return Container(
              margin: const EdgeInsets.all(8),
              width: 50, // Reducido a la mitad
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white70,
                shape: BoxShape.rectangle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 2,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Icon(Icons.send, color: Colors.black, size: 28),
            );
          },
          action: () async {
            widget
                .onSwipedAction(); // Acción cuando el botón se desliza completamente
          },
        ),
      ),
    );
  }
}
