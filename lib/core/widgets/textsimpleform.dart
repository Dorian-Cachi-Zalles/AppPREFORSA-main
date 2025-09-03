import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final String name;
  final String label;
  final bool isRequired;
  final bool isNumeric;
  final bool isreadonly;
  final String? valorInicial;
  final double? min;
  final double? max;
  final int? maxLength;
  final ValueChanged<String?>? onChanged;

  const CustomInputField({
    Key? key,
    required this.name,
    required this.label,
    this.valorInicial,
    this.isRequired = true,
    this.isNumeric = true,
    this.min,
    this.max,
    this.maxLength,
    this.onChanged,
    this.isreadonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: name,
              initialValue: valorInicial,
              readOnly: isreadonly,
              onChanged: onChanged,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
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
                // suffixIcon: _buildSuffixIcon(),
              ),
              validator: FormBuilderValidators.compose([
                if (isRequired)
                  FormBuilderValidators.required(
                      errorText: 'El campo no puede estar vacío'),
                if (isNumeric)
                  FormBuilderValidators.numeric(
                      errorText: 'Debe ser un número válido'),
                if (!isNumeric && maxLength != null)
                  FormBuilderValidators.maxLength(maxLength!,
                      errorText: 'Máximo $maxLength palabras'),
              ]),
            ),
            //_buildText(),
          ],
        ),
      ),
    );
  }
}

class CustomInputFieldMM extends StatelessWidget {
  final String name;
  final String label;
  final String? valorInicial;
  final Future<void> Function()? onPress;
  final IconData? iconoopcional;

  const CustomInputFieldMM({
    Key? key,
    required this.name,
    required this.label,
    this.valorInicial,
    this.onPress,
    this.iconoopcional,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: name,
              initialValue: valorInicial,
              readOnly: true,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
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
                suffixIcon: onPress != null
                    ? IconButton(
                        icon: Icon(
                          iconoopcional ?? Icons.refresh,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPressed: onPress,
                      )
                    : null,
              ),
            ),
            //_buildText(),
          ],
        ),
      ),
    );
  }
}

class CustomInputFieldPeque extends StatelessWidget {
  final String name;
  final String label;
  final bool isRequired;
  final bool isNumeric;
  final bool isreadonly;
  final String? valorInicial;
  final double? min;
  final double? max;
  final int? maxLength;
  final ValueChanged<String?>? onChanged;

  const CustomInputFieldPeque({
    Key? key,
    required this.name,
    required this.label,
    this.valorInicial,
    this.isRequired = true,
    this.isNumeric = true,
    this.min,
    this.max,
    this.maxLength,
    this.onChanged,
    this.isreadonly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: name,
              initialValue: valorInicial,
              readOnly: isreadonly,
              onChanged: onChanged,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
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
                // suffixIcon: _buildSuffixIcon(),
              ),
              validator: FormBuilderValidators.compose([
                if (isRequired)
                  FormBuilderValidators.required(
                      errorText: 'El campo no puede estar vacío'),
                if (isNumeric)
                  FormBuilderValidators.numeric(
                      errorText: 'Debe ser un número válido'),
                if (!isNumeric && maxLength != null)
                  FormBuilderValidators.maxLength(maxLength!,
                      errorText: 'Máximo $maxLength palabras'),
              ]),
            ),
            //_buildText(),
          ],
        ),
      ),
    );
  }
}
