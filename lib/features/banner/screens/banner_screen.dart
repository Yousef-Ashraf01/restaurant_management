import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/auth/state/banner_cubit.dart';
import 'package:restaurant_management/features/auth/state/banner_state.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء Cubit لما الصفحة تفتح
    context.read<BannerCubit>().getBanners();

    return Scaffold(
      appBar: AppBar(title: const Text("Banners")),
      body: BlocBuilder<BannerCubit, BannerState>(
        builder: (context, state) {
          if (state is BannerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BannerError) {
            return Center(child: Text("Error: ${state.message}"));
          } else if (state is BannerLoaded) {
            final banners = state.banners;
            if (banners.isEmpty) {
              return const Center(child: Text("No Banners Found"));
            }

            return ListView.builder(
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(banner.name, style: const TextStyle(fontSize: 18)),
                      Image.memory(
                        convertBase64ToImage(banner.image),
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // الحالة الافتراضية
          return const Center(child: Text("Waiting for banners..."));
        },
      ),
    );
  }
}
