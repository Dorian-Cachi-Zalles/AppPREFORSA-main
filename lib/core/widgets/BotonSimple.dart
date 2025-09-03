import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonSimple extends StatelessWidget {
  final VoidCallback? onPressed;
  final String texto;
  final Color colorBoton;
  final IconData icono;

  const BotonSimple({
    super.key,
    this.onPressed,
    required this.texto,
    required this.colorBoton,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * 0.75; // máximo 75% del ancho
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(40),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colorBoton,
                      Color.alphaBlend(
                          Colors.white.withOpacity(0.25), colorBoton),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icono, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        texto,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
