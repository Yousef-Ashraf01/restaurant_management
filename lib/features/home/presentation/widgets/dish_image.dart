import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management/core/utils/image_utils.dart';

class DishImage extends StatefulWidget {
  final String image;
  final int dishId;

  const DishImage({super.key, required this.image, required this.dishId});

  @override
  State<DishImage> createState() => _DishImageState();
}

class _DishImageState extends State<DishImage> {
  static final Map<int, Uint8List> _cache = {};
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();

    if (_cache.containsKey(widget.dishId) && widget.image.isNotEmpty) {
      _imageBytes = _cache[widget.dishId]!;
    } else {
      _imageBytes =
          (widget.image.isNotEmpty && widget.image != "null")
              ? convertBase64ToImage(widget.image)
              : Uint8List(0);
      if (widget.image.isNotEmpty) {
        _cache[widget.dishId] = _imageBytes;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _imageBytes.isNotEmpty;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child:
            hasImage
                ? Image.memory(
                  _imageBytes,
                  width: 220.w,
                  height: 160.h,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                )
                : Image.asset(
                  "assets/images/logo1.jpg",
                  width: 200.w,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
      ),
    );
  }
}
