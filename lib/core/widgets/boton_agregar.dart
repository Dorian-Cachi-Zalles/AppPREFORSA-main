import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonAgregar extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? textoopcional;
  final Color colorcito;
  final IconData? iconoopcional;

  const BotonAgregar({
    super.key,
    this.onPressed,
    this.textoopcional,
    required this.colorcito,
    this.iconoopcional,
  });

  @override
  Widget build(BuildContext context) {
    final bool setienetext = textoopcional != null && textoopcional!.isNotEmpty;
    return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
            height: 53,
            width: double.infinity,
            child: Container(
                decoration: BoxDecoration(
                  color: colorcito,
                  borderRadius:
                      BorderRadius.circular(8), // Ajusta según lo necesites
                ),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                      ),
                    ),
                    onPressed: onPressed,
                    icon: Icon(
                      iconoopcional ?? Icons.add,
                      color: Colors.black,
                      size: 25,
                    ),
                    label: Text(
                      setienetext ? textoopcional! : 'AGREGAR UN REGISTRO',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )))));
  }
}
