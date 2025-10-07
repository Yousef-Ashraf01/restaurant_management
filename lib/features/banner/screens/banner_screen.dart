import 'package:flutter/material.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';
import 'package:restaurant_management/features/auth/data/datasources/banner_service.dart';
import 'package:restaurant_management/features/auth/data/models/banner_model.dart';

class BannerScreen extends StatelessWidget {
  final BannerService bannerService = BannerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banners")),
      body: FutureBuilder<List<BannerModel>>(
        future: bannerService.getBanners(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No Banners Found"));
          }

          final banners = snapshot.data!;
          return ListView.builder(
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(banner.name, style: TextStyle(fontSize: 18)),
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
        },
      ),
    );
  }
}
