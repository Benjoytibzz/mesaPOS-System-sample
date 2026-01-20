import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class CryptoUtil {
  static final Key _key =
      Key.fromUtf8('32charslongsecretkeyforposapp!');
  static final IV _iv = IV.fromLength(16);
  static final Encrypter _encrypter = Encrypter(AES(_key));

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static String encrypt(String value) {
    return _encrypter.encrypt(value, iv: _iv).base64;
  }

  static String decrypt(String value) {
    return _encrypter.decrypt64(value, iv: _iv);
  }
}
