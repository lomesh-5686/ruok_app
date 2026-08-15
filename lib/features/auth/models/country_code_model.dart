import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class CountryCodeModel {
  final String name;
  final String dialCode;
  final String code;

  const CountryCodeModel({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      name: json['name'] as String? ?? '',
      dialCode: json['dial_code'] as String? ?? '',
      code: (json['iso'] as String?) ?? (json['code'] as String?) ?? '',
    );
  }

  static Future<List<CountryCodeModel>> loadFromAsset() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/country_codes.json');
    return compute(_parseCountries, jsonString);
  }
}

List<CountryCodeModel> _parseCountries(String jsonString) {
  final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
  return list
      .map((item) => CountryCodeModel.fromJson(item as Map<String, dynamic>))
      .toList();
}
