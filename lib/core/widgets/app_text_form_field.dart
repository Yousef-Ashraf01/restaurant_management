import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/constants/app_colors.dart';

class AppTextFormField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final bool isRequired; // ✅ جديد
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextFormField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.isRequired = false, // ✅ default false
    this.controller,
    this.keyboardType,
    required this.validator,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    if (!widget.isPassword) _obscureText = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
            SizedBox(width: 3.w,),
            if (widget.isRequired)
              const Text(
                " *",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        TextFormField(
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          obscureText: _obscureText,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: AppColors.text),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}
