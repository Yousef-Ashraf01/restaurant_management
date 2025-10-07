import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/auth/domain/repositories/banner_repository.dart';
import 'package:restaurant_management/features/auth/state/banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final BannerRepository repository;

  BannerCubit(this.repository) : super(BannerInitial());

  Future<void> getBanners() async {
    emit(BannerLoading());
    try {
      final banners = await repository.getBanners();
      print("🖼️ Loaded ${banners.length} banners");
      emit(BannerLoaded(banners));
    } catch (e) {
      print("❌ Failed to load banners: $e");
      emit(BannerError(e.toString()));
    }
  }
}
