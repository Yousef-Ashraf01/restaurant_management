import 'dart:convert';
import 'dart:typed_data';

Uint8List convertBase64ToImage(String base64String) {
  return base64Decode(base64String);
}
