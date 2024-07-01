import 'dart:convert';
import 'package:http/http.dart' as http;

/*
Telefon numarası doğrulamak için  api_key ini :

https://api-ninjas.com/register

siteye kaydolarak profil sayfası api key kısmından alabilirsiniz.

*/

class PhoneValidationService {
  final String apiKey = "SECRET_API_KEY";

  Future<Map<String, dynamic>> validatePhoneNumber(String phoneNumber) async {
    final url = Uri.parse(
        'https://api.api-ninjas.com/v1/validatephone?number=$phoneNumber');

    final response = await http.get(url, headers: {
      'X-Api-Key': apiKey,
    });

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to validate phone number');
    }
  }
}
