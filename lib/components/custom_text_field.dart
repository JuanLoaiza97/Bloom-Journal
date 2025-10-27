import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    this.label, // 🔹 Ya no es obligatorio
    required this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.placeholder,
    this.validator,
  }) : super(key: key);

  final String? label; // 🔹 Opcional
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? placeholder;
  final FormFieldValidator<String>? validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
  }

  void toggleObscured() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color borderColor = Color(0xFF6C63FF); // 💜 color del borde

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          obscureText: _isObscured,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color: borderColor,
                    ),
                    onPressed: toggleObscured,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
