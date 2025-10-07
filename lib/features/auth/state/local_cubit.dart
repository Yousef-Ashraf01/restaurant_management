import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')); // default English

  static Future<LocaleCubit> create() async {
    final cubit = LocaleCubit();
    await cubit.loadLocale();
    return cubit;
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale') ?? 'en';
    emit(Locale(langCode));
  }

  Future<void> changeLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', langCode);
    emit(Locale(langCode));
  }
}
