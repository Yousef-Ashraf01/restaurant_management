import 'dart:typed_data';

import 'package:restaurant_management/core/utils/image_utils.dart';

class DishImageCache {
  static final Map<int, Uint8List> _cache = {};

  static Uint8List? getImage(int dishId, String base64Image) {
    if (base64Image.isEmpty || base64Image == "null") return null;
    if (_cache.containsKey(dishId)) return _cache[dishId];
    final bytes = convertBase64ToImage(base64Image);
    _cache[dishId] = bytes;
    return bytes;
  }

  static void clear() => _cache.clear();
}
