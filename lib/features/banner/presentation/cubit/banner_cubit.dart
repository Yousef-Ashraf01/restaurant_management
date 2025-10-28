import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/banner/data/repositories/banner_repository.dart';
import 'package:restaurant_management/features/banner/presentation/cubit/banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final BannerRepository repository;

  BannerCubit(this.repository) : super(BannerInitial());

  Future<void> getBanners({bool forceRefresh = false}) async {
    if (state is BannerLoaded && !forceRefresh) return;
    emit(BannerLoading());
    try {
      final banners = await repository.getBanners();
      print("Loaded ${banners.length} banners");
      emit(BannerLoaded(banners));
    } catch (e) {
      print("Failed to load banners: $e");
      emit(BannerError(e.toString()));
    }
  }
}
