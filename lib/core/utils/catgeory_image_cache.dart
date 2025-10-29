import 'dart:typed_data';

import 'package:restaurant_management/core/utils/image_utils.dart';

class CategoryImageCache {
  static final Map<int, Uint8List> _cache = {};

  static Uint8List? getImage(int categoryId, String base64Image) {
    if (base64Image.isEmpty) return null;
    if (_cache.containsKey(categoryId)) return _cache[categoryId];
    final bytes = convertBase64ToImage(base64Image);
    _cache[categoryId] = bytes;
    return bytes;
  }

  static void clear() => _cache.clear();
}
