import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownSimple<T> extends StatelessWidget {
  final String name;
  final String label;
  final T? valorInicial;
  final bool? isrequerid;
  final String textoError;
  final Map<String, List<dynamic>> dropOptions;
  final String opciones;
  final ValueChanged<T?>? onChanged;

  const DropdownSimple({
    Key? key,
    required this.name,
    required this.label,
    required this.textoError,
    required this.opciones,
    this.valorInicial,
    this.onChanged,
    required this.dropOptions,
    this.isrequerid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Color de fondo del campo
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FormBuilderDropdown<T>(
          name: name,
          initialValue: valorInicial,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
            // Validación manual del campo (opcional)
            final field = FormBuilder.of(context)?.fields[name];
            field?.validate();
            field?.save();
          },
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
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
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 13,
              height: 1,
              color: Colors.red,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
          ),
          items: dropOptions[opciones]!
              .map((option) => DropdownMenuItem<T>(
                    value: option as T,
                    child: Text(option.toString()),
                  ))
              .toList(),
          validator: isrequerid == true
              ? FormBuilderValidators.required(
                  errorText: textoError,
                )
              : null,
        ),
      ),
    );
  }
}

class DropdownSimpleLIST<T> extends StatelessWidget {
  final String name;
  final String label;
  final T? valorInicial;
  final bool? isRequerid;
  final String textoError;
  final List<T> dropOptions; // Cambié a List<T> para que sea genérico
  final ValueChanged<T?>? onChanged;

  const DropdownSimpleLIST({
    Key? key,
    required this.name,
    required this.label,
    required this.textoError,
    this.valorInicial,
    this.onChanged,
    required this.dropOptions,
    this.isRequerid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FormBuilderDropdown<T>(
          name: name,
          initialValue: valorInicial,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
            // Validación manual del campo (opcional)
            final field = FormBuilder.of(context)?.fields[name];
            field?.validate();
            field?.save();
          },
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
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
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              height: 1,
              color: Colors.red,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
          ),
          items: dropOptions
              .map((e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(e.toString()),
                  ))
              .toList(),
          validator: isRequerid == true
              ? FormBuilderValidators.required(
                  errorText: textoError,
                )
              : null,
        ),
      ),
    );
  }
}
