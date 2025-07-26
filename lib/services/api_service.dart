import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // Necessário para SocketException

class ApiService {
  // Sua chave de API. Lembre-se de manter em segurança em um ambiente de produção.
  static const String _apiKey = '4a76613ba52c5e0312334987';
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6';
  static const String _baseCurrency = 'USD'; // Moeda base para as cotações

  static Future<Map<String, dynamic>?> fetchCurrencies() async {
    // Construção da URI com a chave da API e moeda base
    final uri = Uri.parse('$_baseUrl/$_apiKey/latest/$_baseCurrency');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Verifica se a resposta foi um sucesso e contém as taxas de conversão
        if (data['result'] == 'success' && data.containsKey('conversion_rates')) {
          // Retorna um mapa contendo as taxas de conversão e a data/hora da última atualização
          return {
            'conversion_rates': data['conversion_rates'],
            'time_last_update_utc': data['time_last_update_utc'], // Extraído da resposta da API
          };
        } else {
          // Caso a API retorne um erro (ex: chave inválida, etc.)
          if (kDebugMode) {
            print('Erro na resposta da API: ${data['error-type'] ?? 'Desconhecido'}');
          }
          return null;
        }
      } else {
        // Caso a requisição HTTP falhe (ex: 404, 500, etc.)
        if (kDebugMode) {
          print('Falha na requisição (Status: ${response.statusCode}): ${response.body}');
        }
        return null;
      }
    } on SocketException {
      // Captura erros de conexão (ex: sem internet, host inacessível)
      if (kDebugMode) {
        print('Erro de conexão: Verifique sua internet.');
      }
      // Relança uma exceção para que o FutureBuilder possa capturar e exibir uma mensagem específica
      throw Exception('Sem conexão com a internet. Verifique sua conexão.');
    } catch (e) {
      // Captura quaisquer outros erros inesperados
      if (kDebugMode) {
        print('Ocorreu um erro inesperado ao buscar dados da API: $e');
      }
      return null;
    }
  }
}
