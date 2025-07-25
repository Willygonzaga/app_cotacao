import 'package:flutter/foundation.dart'; // Mantido, boa prática
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = '4a76613ba52c5e0312334987'; // Sua chave de API
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String _baseCurrency = 'USD'; // Moeda base para as cotações

  static Future<Map<String, dynamic>?> fetchCurrencies() async {
    // AQUI ESTÁ A CORREÇÃO NA CONSTRUÇÃO DA URL
    final uri = Uri.parse('$_baseUrl/$_apiKey/latest/$_baseCurrency');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['result'] == 'success' && data.containsKey('conversion_rates')) {
          return data['conversion_rates'];
        } else {
          if (kDebugMode) {
            print('Erro na resposta da API: ${data['error-type']}');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('Falha na requisição (Status: ${response.statusCode}): ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Ocorreu um erro ao buscar dados da API: $e');
      }
      return null;
    }
  }
}