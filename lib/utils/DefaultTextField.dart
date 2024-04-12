import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {

  String label;
  String? initialValue;
  String? errorText;
  TextInputType? textInputType;
  IconData icon;
  Color? color;
  Function(String text) onChanged;
  String? Function(String?)? validator;
  bool obscureText;

  DefaultTextField({
    Key? key,
    required this.label,
    required this.icon,
    required this.onChanged,
    this.errorText,
    this.validator,
    this.obscureText = false,
    this.initialValue,
    this.color = Colors.white,
    textInputType = TextInputType.text
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      initialValue: initialValue,
      onChanged: (text) {
        onChanged(text);
      },
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
        label: Text(
          label,
          style: TextStyle(
            color: color
          ),
        ),
        errorText: errorText,
        prefixIcon: Icon(
          icon,
          color: color,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color!)
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color!)
        ),
      ),
      style: TextStyle(
        color: color
      ),
    );
  }
}