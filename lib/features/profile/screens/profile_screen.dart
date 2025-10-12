import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart'; // لازم تستورد Lottie
import 'package:restaurant_management/core/constants/app_colors.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/auth/data/models/profile_response_model.dart';
import 'package:restaurant_management/features/auth/domain/repositories/address_repository.dart';
import 'package:restaurant_management/features/auth/domain/repositories/profile_repository.dart';
import 'package:restaurant_management/features/auth/state/address_cubit.dart';
import 'package:restaurant_management/features/auth/state/connectivity_cubit.dart';
import 'package:restaurant_management/features/auth/state/profile_cubit.dart';
import 'package:restaurant_management/features/auth/state/profile_state.dart';
import 'package:restaurant_management/features/profile/widgets/address_header.dart';
import 'package:restaurant_management/features/profile/widgets/address_list.dart';
import 'package:restaurant_management/features/profile/widgets/build_text_form_field.dart';
import 'package:restaurant_management/features/profile/widgets/label.dart';
import 'package:restaurant_management/features/profile/widgets/read_only_field.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String token;

  const ProfileScreen({super.key, required this.userId, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  late ProfileCubit _profileCubit;
  late AddressCubit _addressCubit;
  late Future<void> _initCubits;

  bool _fieldsPopulated = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    final profileRepository = context.read<ProfileRepository>();
    final addressRepository = context.read<AddressRepository>();

    _profileCubit = ProfileCubit(profileRepository);
    _addressCubit = AddressCubit(addressRepository);

    _initCubits = _initializeCubits();
  }

  Future<void> _initializeCubits() async {
    _profileCubit.fetchProfile(widget.userId, widget.token);
    _addressCubit.getUserAddresses(widget.userId);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _profileCubit.close();
    _addressCubit.close();
    super.dispose();
  }

  void _populateFields(ProfileData profile) {
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _phoneController.text = profile.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) {
          // حالة عدم وجود إنترنت
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.profile),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Lottie.asset(
                      'assets/animations/noInternetConnection.json',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.noInternetConnection,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // النت موجود → عرض البروفايل
        return FutureBuilder(
          future: _initCubits,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _profileCubit),
                BlocProvider.value(value: _addressCubit),
              ],
              child: AppUnfocusWrapper(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context)!.profile),
                    centerTitle: true,
                  ),
                  body: BlocListener<ConnectivityCubit, bool>(
                    listener: (context, isConnected) {
                      if (isConnected) {
                        _profileCubit.fetchProfile(widget.userId, widget.token);
                        _addressCubit.getUserAddresses(widget.userId);
                      }
                    },
                    child: BlocConsumer<ProfileCubit, ProfileState>(
                      listener: (context, state) {
                        if (state is ProfileError) {
                          setState(() => _isUpdating = false);
                          showAppSnackBar(
                            context,
                            message: state.message,
                            type: SnackBarType.error,
                          );
                        } else if (state is ProfileUpdateSuccess) {
                          setState(() => _isUpdating = false);
                          showAppSnackBar(
                            context,
                            message:
                                AppLocalizations.of(
                                  context,
                                )!.profileUpdatedSuccess,
                            type: SnackBarType.success,
                          );
                          _profileCubit.fetchProfile(
                            widget.userId,
                            widget.token,
                          );
                        }
                      },

                      builder: (context, state) {
                        if (state is ProfileSuccess) {
                          final profile = state.profile.data!;
                          if (!_fieldsPopulated) {
                            _populateFields(profile);
                            _fieldsPopulated = true;
                          }

                          return Stack(
                            children: [
                              SafeArea(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.w,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 15.h),
                                        Center(
                                          child: CircleAvatar(
                                            radius: 50.r,
                                            backgroundColor: Colors.blue,
                                            child: const Icon(
                                              Icons.person,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Center(
                                          child: Text(
                                            "${_firstNameController.text} ${_lastNameController.text}",
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Label(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.firstName,
                                                  ),
                                                  buildTextFormField(
                                                    controller:
                                                        _firstNameController,
                                                    hintText:
                                                        AppLocalizations.of(
                                                          context,
                                                        )!.firstName,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return AppLocalizations.of(
                                                          context,
                                                        )!.firstNameEmpty;
                                                      }
                                                      if (value.trim().length <
                                                          2) {
                                                        return AppLocalizations.of(
                                                          context,
                                                        )!.firstNameShort;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Label(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.lastName,
                                                  ),
                                                  buildTextFormField(
                                                    controller:
                                                        _lastNameController,
                                                    hintText:
                                                        AppLocalizations.of(
                                                          context,
                                                        )!.lastName,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value
                                                              .trim()
                                                              .isEmpty) {
                                                        return AppLocalizations.of(
                                                          context,
                                                        )!.lastNameEmpty;
                                                      }
                                                      if (value.trim().length <
                                                          2) {
                                                        return AppLocalizations.of(
                                                          context,
                                                        )!.lastNameShort;
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Label(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.userName,
                                                  ),
                                                  ReadOnlyField(
                                                    profile.userName,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Label(
                                                    AppLocalizations.of(
                                                      context,
                                                    )!.email,
                                                  ),
                                                  ReadOnlyField(profile.email),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.h),
                                        Label(
                                          AppLocalizations.of(
                                            context,
                                          )!.phoneNumber,
                                        ),
                                        buildTextFormField(
                                          controller: _phoneController,
                                          hintText:
                                              AppLocalizations.of(
                                                context,
                                              )!.phoneNumber,
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return AppLocalizations.of(
                                                context,
                                              )!.phoneNumberEmpty;
                                            }
                                            if (!RegExp(
                                              r'^\d{11}$',
                                            ).hasMatch(value.trim())) {
                                              return AppLocalizations.of(
                                                context,
                                              )!.phoneNumberLength;
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 30.h),
                                        Center(
                                          child: SizedBox(
                                            width: 200.w,
                                            height: 45.h,
                                            child: ElevatedButton(
                                              onPressed:
                                                  _isUpdating
                                                      ? null // تعطيل الزر أثناء التحميل
                                                      : () {
                                                        if (_formKey
                                                            .currentState!
                                                            .validate()) {
                                                          setState(
                                                            () =>
                                                                _isUpdating =
                                                                    true,
                                                          );
                                                          _profileCubit.updateProfile(
                                                            profile.copyWith(
                                                              firstName:
                                                                  _firstNameController
                                                                      .text
                                                                      .trim(),
                                                              lastName:
                                                                  _lastNameController
                                                                      .text
                                                                      .trim(),
                                                              phoneNumber:
                                                                  _phoneController
                                                                      .text
                                                                      .trim(),
                                                            ),
                                                            widget.token,
                                                          );
                                                        }
                                                      },
                                              child:
                                                  _isUpdating
                                                      ? SizedBox(
                                                        height: 22.h,
                                                        width: 22.h,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2.5,
                                                              color:
                                                                  AppColors
                                                                      .primary,
                                                            ),
                                                      )
                                                      : Text(
                                                        AppLocalizations.of(
                                                          context,
                                                        )!.updateProfile,
                                                      ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 30.h),
                                        AddressesHeader(userId: widget.userId),
                                        SizedBox(height: 10.h),
                                        AddressList(userId: widget.userId),
                                        SizedBox(height: 20.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        if (state is ProfileLoading && !_fieldsPopulated) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        }

                        if (state is ProfileError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
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
