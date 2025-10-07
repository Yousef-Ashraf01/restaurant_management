import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityCubit extends Cubit<bool> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _sub;

  ConnectivityCubit() : super(true) {
    _init();
  }

  Future<void> _init() async {
    final res = await _connectivity.checkConnectivity();
    emit(res != ConnectivityResult.none);
    _sub = _connectivity.onConnectivityChanged.listen((result) {
      emit(result != ConnectivityResult.none);
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
