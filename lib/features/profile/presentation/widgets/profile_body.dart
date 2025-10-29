import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/features/profile/data/models/profile_response_model.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/address_header.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/address_list.dart';
import 'package:shimmer/shimmer.dart';

import 'profile_avatar.dart';
import 'profile_form.dart';
import 'update_button.dart';

class ProfileBody extends StatefulWidget {
  final ProfileData profile;
  final String token;
  final bool isUpdating;

  const ProfileBody({
    super.key,
    required this.profile,
    required this.token,
    required this.isUpdating,
  });

  // 👇👇👇 نضيف دي هنا
  static Widget skeleton() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة البروفايل
            ShimmerBox(width: 100.w, height: 100.w, shape: BoxShape.circle),
            SizedBox(height: 20.h),

            // First Name + Last Name في صف واحد
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 60.w, height: 16.h),
                      SizedBox(height: 8.h),
                      ShimmerBox(width: double.infinity, height: 45.h),
                    ],
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 60.w, height: 16.h),
                      SizedBox(height: 8.h),
                      ShimmerBox(width: double.infinity, height: 45.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Phone Number + Email
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 80.w, height: 16.h),
                      SizedBox(height: 8.h),
                      ShimmerBox(width: double.infinity, height: 45.h),
                    ],
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 60.w, height: 16.h),
                      SizedBox(height: 8.h),
                      ShimmerBox(width: double.infinity, height: 45.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.h),

            // زرار التحديث
            ShimmerBox(width: double.infinity, height: 50.h, radius: 12.r),
            SizedBox(height: 30.h),

            // Address title
            Align(
              alignment: Alignment.centerLeft,
              child: ShimmerBox(width: 100.w, height: 16.h),
            ),
            SizedBox(height: 12.h),

            // Address list items (2 أو 3)
            for (int i = 0; i < 2; i++) ...[
              ShimmerBox(width: double.infinity, height: 70.h, radius: 10.r),
              SizedBox(height: 12.h),
            ],
          ],
        ),
      ),
    );
  }

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.profile.firstName);
    _lastName = TextEditingController(text: widget.profile.lastName);
    _phone = TextEditingController(text: widget.profile.phoneNumber);
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 15.h),
              ProfileAvatar(name: "${_firstName.text} ${_lastName.text}"),
              SizedBox(height: 20.h),
              ProfileForm(
                firstNameController: _firstName,
                lastNameController: _lastName,
                phoneController: _phone,
                email: widget.profile.email,
              ),
              SizedBox(height: 30.h),
              UpdateButton(
                isUpdating: widget.isUpdating,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updated = widget.profile.copyWith(
                      firstName: _firstName.text.trim(),
                      lastName: _lastName.text.trim(),
                      phoneNumber: _phone.text.trim(),
                    );
                    context.read<ProfileCubit>().updateProfile(
                      updated,
                      widget.token,
                    );
                  }
                },
              ),
              SizedBox(height: 30.h),
              AddressesHeader(userId: widget.profile.id),
              SizedBox(height: 10.h),
              AddressList(userId: widget.profile.id),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

extension ProfileDataCopy on ProfileData {
  ProfileData copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return ProfileData(
      id: id,
      userName: userName,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roles: roles,
      isActive: isActive,
      addresses: addresses,
      primaryAddress: primaryAddress,
      addressCount: addressCount,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double? radius;
  final BoxShape? shape;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius:
              shape == BoxShape.circle
                  ? null
                  : BorderRadius.circular(radius ?? 8.r),
          shape: shape ?? BoxShape.rectangle,
        ),
      ),
    );
  }
}
