import 'package:restaurant_management/features/auth/data/models/banner_model.dart';

abstract class BannerState {}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerModel> banners;
  BannerLoaded(this.banners);
}

class BannerError extends BannerState {
  final String message;
  BannerError(this.message);
}
