import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/profile_cubit.dart';
import 'package:restaurant_management/features/auth/state/profile_state.dart';
import 'package:restaurant_management/features/profile/widgets/address_header.dart';
import 'package:restaurant_management/features/profile/widgets/address_list.dart';
import 'package:restaurant_management/features/profile/widgets/header.dart';
import 'package:restaurant_management/features/profile/widgets/label.dart';
import 'package:restaurant_management/features/profile/widgets/read_only_field.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final String token;

  const ProfileScreen({required this.userId, required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => ProfileCubit(context.read())..fetchProfile(userId, token),
        ),
        BlocProvider(
          create: (_) => AddressCubit(context.read())..getUserAddresses(userId),
        ),
      ],
      child: AppUnfocusWrapper(
        child: Scaffold(
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else if (state is ProfileSuccess) {
                final profile = state.profile.data!;
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 15.h),
                        const Header(),
                        SizedBox(height: 25.h),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 50.r,
                          child: const Icon(Icons.person, size: 50),
                        ),
                        SizedBox(height: 20.h),
                        const Label("User Name"),
                        ReadOnlyField(profile.userName),
                        SizedBox(height: 20.h),
                        const Label("Email"),
                        ReadOnlyField(profile.email),
                        SizedBox(height: 30.h),
                        AddressesHeader(userId: userId),
                        SizedBox(height: 10.h),
                        AddressList(userId: userId),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
