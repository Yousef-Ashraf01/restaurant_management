import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_management/core/network/connectivity_cubit.dart';
import 'package:restaurant_management/core/network/token_storage.dart';
import 'package:restaurant_management/core/utils/show_snack_bar.dart';
import 'package:restaurant_management/core/widgets/app_un_focus_wrapper.dart';
import 'package:restaurant_management/features/profile/data/repositories/address_repository.dart';
import 'package:restaurant_management/features/profile/data/repositories/profile_repository.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/address_cubit.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:restaurant_management/features/profile/presentation/cubit/profile_state.dart';
import 'package:restaurant_management/features/profile/presentation/widgets/profile_body.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String token;

  const ProfileScreen({super.key, required this.userId, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit _profileCubit;
  late AddressCubit _addressCubit;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    final profileRepo = context.read<ProfileRepository>();
    final addressRepo = context.read<AddressRepository>();
    final tokenStorage = context.read<TokenStorage>();

    _profileCubit = ProfileCubit(profileRepo);
    _addressCubit = AddressCubit(addressRepo, tokenStorage);

    // ✅ تحميل البيانات مرة واحدة فقط
    _profileCubit.fetchProfile(widget.userId, widget.token);
    _addressCubit.getUserAddresses(widget.userId);
  }

  @override
  void dispose() {
    _profileCubit.close();
    _addressCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, isConnected) {
        if (!isConnected) return _buildNoInternet(context);

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
                listener: (context, connected) {
                  if (connected) {
                    // ✅ تحديث فقط لو النت رجع بعد انقطاع
                    _profileCubit.fetchProfile(widget.userId, widget.token);
                    _addressCubit.getUserAddresses(widget.userId);
                  }
                },
                child: BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileUpdating) {
                      setState(() => _isUpdating = true);
                    } else if (state is ProfileUpdateSuccess) {
                      setState(() => _isUpdating = false);
                      showAppSnackBar(
                        context,
                        message:
                            AppLocalizations.of(context)!.profileUpdatedSuccess,
                        type: SnackBarType.success,
                      );
                    } else if (state is ProfileError) {
                      setState(() => _isUpdating = false);
                      showAppSnackBar(
                        context,
                        message: state.message,
                        type: SnackBarType.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileSuccess) {
                      return ProfileBody(
                        profile: state.profile.data!,
                        token: widget.token,
                        isUpdating: _isUpdating,
                      );
                    }

                    // if (state is ProfileLoading) {
                    //   return const Center(child: CircularProgressIndicator());
                    // }

                    if (state is ProfileLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: ProfileBody.skeleton(),
                      );
                    }

                    if (state is ProfileError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
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
  }

  Widget _buildNoInternet(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/noInternetConnection.json',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noInternetConnection,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
