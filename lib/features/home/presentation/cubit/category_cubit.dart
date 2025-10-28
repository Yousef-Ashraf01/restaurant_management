import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/features/home/data/repositories/category_repository.dart';
import 'package:restaurant_management/features/home/presentation/cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;

  CategoryCubit(this.repository) : super(CategoryInitial());

  Future<void> getCategories({bool forceRefresh = false}) async {
    if (state is CategoryLoaded && !forceRefresh) return;

    emit(CategoryLoading());
    try {
      final categories = await repository.fetchCategories();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
