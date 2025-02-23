import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateSalt([int length = 16]) {
  final random = Random.secure();
  final salt = List<int>.generate(length, (_) => random.nextInt(256));
  return base64Url.encode(salt);
}

String hashPassword(String password, String salt) {
  final bytes = utf8.encode(password + salt);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

bool verifyPassword(String password, String salt, String hash) {
  final hashedPassword = hashPassword(password, salt);
  return hashedPassword == hash;
}
