import 'package:flutter/material.dart';

import '../loader/circular_indicator.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    this.inputType,
    this.labelText,
    this.hintText,
    this.isLoading = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final TextInputType? inputType;
  final String? labelText, hintText;
  final bool isLoading;
  final bool readOnly;
  final int maxLines;
  final void Function(String?)? onChanged;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        readOnly: readOnly,
        autofocus: autofocus,
        focusNode: focusNode,
        keyboardType: inputType ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          suffixIcon: isLoading ? CircularIndicator() : SizedBox.shrink(),
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (val) {
          if (onChanged != null) {
            onChanged!(val);
          }
        },
        validator: (val) {
          if (val!.isEmpty) {
            return "Field cannot be empty";
          }
          return null;
        },
      ),
    );
  }
}
