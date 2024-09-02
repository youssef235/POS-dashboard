import 'package:flutter/material.dart';

Widget buildAddTextFormField({
  required String label,
  required String initialValue,
  TextInputType keyboardType = TextInputType.text,
  required FormFieldSetter<String> onSaved,
  required FormFieldValidator<String> validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onSaved: onSaved,
      validator: validator,
    ),
  );
}
