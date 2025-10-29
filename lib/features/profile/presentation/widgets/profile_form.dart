import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/build_text_form_field.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/label.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/read_only_field.dart';

class ProfileForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final String email;

  const ProfileForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildField(
                context,
                label: AppLocalizations.of(context)!.firstName,
                controller: firstNameController,
                validator: (v) {
                  if (v!.isEmpty)
                    return AppLocalizations.of(context)!.firstNameEmpty;
                  if (v.length < 2)
                    return AppLocalizations.of(context)!.firstNameShort;
                  return null;
                },
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: _buildField(
                context,
                label: AppLocalizations.of(context)!.lastName,
                controller: lastNameController,
                validator: (v) {
                  if (v!.isEmpty)
                    return AppLocalizations.of(context)!.lastNameEmpty;
                  if (v.length < 2)
                    return AppLocalizations.of(context)!.lastNameShort;
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: _buildField(
                context,
                label: AppLocalizations.of(context)!.phoneNumber,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v!.isEmpty)
                    return AppLocalizations.of(context)!.phoneNumberEmpty;
                  if (!RegExp(r'^\d{11}$').hasMatch(v)) {
                    return AppLocalizations.of(context)!.phoneNumberLength;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(AppLocalizations.of(context)!.email),
                  ReadOnlyField(email),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(label),
        buildTextFormField(
          controller: controller,
          hintText: label,
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.text,
        ),
      ],
    );
  }
}
