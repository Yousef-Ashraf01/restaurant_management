import 'dart:typed_data';

import 'package:restaurant_management/core/utils/image_utils.dart';

class BannerImageCache {
  static final Map<int, Uint8List> _cache = {};

  static Uint8List getImage(int bannerId, String base64Image) {
    if (_cache.containsKey(bannerId)) {
      return _cache[bannerId]!;
    }
    final bytes = convertBase64ToImage(base64Image);
    _cache[bannerId] = bytes;
    return bytes;
  }

  static void clear() => _cache.clear();
}
