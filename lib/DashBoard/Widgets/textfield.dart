import 'package:flutter/material.dart';

Widget buildTextFormField(context, var addedValue, String labeltext) {
  return TextFormField(
    decoration: InputDecoration(labelText: labeltext),
    onSaved: (value) => addedValue = value!,
    validator: (value) => value!.isEmpty ? 'Not Valid' : null,
  );
}
