import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Titulos extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final int tipo;
  final VoidCallback? accion;

  const Titulos({
    super.key,
    required this.titulo,
    required this.tipo,
    this.accion,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    final bool tieneSubtitulo = subtitulo != null && subtitulo!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Text(
            titulo,
            style: GoogleFonts.quicksand(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.start,
          ),
          const Spacer(),
          if (tipo == 1)
            GestureDetector(
              onTap: accion,
              child: Text(
                tieneSubtitulo ? subtitulo! : 'Borrar Todo',
                style: GoogleFonts.quicksand(
                  color: tieneSubtitulo ? Colors.blue : Colors.red,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          const SizedBox(width: 23),
        ],
      ),
    );
  }
}
