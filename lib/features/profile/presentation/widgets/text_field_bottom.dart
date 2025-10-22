import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldBottom extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isNumber;
  final bool requiredField;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputAction? textInputAction;
  final VoidCallback? onDone;

  const TextFieldBottom({
    required this.controller,
    required this.label,
    this.isNumber = false,
    this.requiredField = true,
    this.focusNode,
    this.nextFocus,
    this.textInputAction,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      textInputAction: textInputAction ?? TextInputAction.next,
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else {
          FocusScope.of(context).unfocus();
          if (onDone != null) onDone!();
        }
      },
      validator: (value) {
        if (requiredField && (value == null || value.isEmpty)) {
          return "$label ${AppLocalizations.of(context)!.is_required}";
        }
        return null;
      },
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(color: Colors.black87, fontSize: 16.sp),
            children:
                requiredField
                    ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                    ]
                    : [],
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      ),
    );
  }
}
