import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckboxSimple extends StatelessWidget {
  final String name;
  final String label;
  final bool valorInicial;
  final ValueChanged<bool?>? onChanged;

  const CheckboxSimple({
    Key? key,
    required this.name,
    required this.label,
    this.valorInicial = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormBuilderCheckbox(
        name: name,
        title: Text(
          label,
          style: GoogleFonts.poppins(
              fontSize: 17.5, color: Colors.black, fontWeight: FontWeight.w600),
        ),

        initialValue: valorInicial,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 56, 106, 148),
              width: 2.0,
            ),
          ),
        ),
        checkColor: Colors.white, // Color del check
        activeColor: const Color.fromARGB(
            255, 56, 106, 148), // Color del checkbox activo
      ),
    );
  }
}


class CheckboxSimple2 extends StatelessWidget {
  final String name;
  final String label;
  final bool valorInicial;
  final ValueChanged<bool?>? onChanged;

  const CheckboxSimple2({
    Key? key,
    required this.name,
    required this.label,
    this.valorInicial = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormBuilderField<bool>(
        name: name,
        initialValue: valorInicial,
        builder: (field) {
          return InputDecorator(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 56, 106, 148),
                  width: 2.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 17.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Checkbox(
                  value: field.value ?? false,
                  onChanged: (val) {
                    field.didChange(val);
                    if (onChanged != null) {
                      onChanged!(val);
                    }
                  },
                  checkColor: Colors.white,
                  activeColor: const Color.fromARGB(255, 56, 106, 148),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
