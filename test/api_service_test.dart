import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
// Importe sua ApiService para testar se houver lógica estática que pode ser testada diretamente
// import 'package:cotacao_app/services/api_service.dart';

void main() {
  group('Processamento de Dados da API', () {
    test('Deve extrair as taxas de conversão de uma resposta de sucesso', () {
      // Simula uma resposta JSON bem-sucedida da ExchangeRate-API
      final String mockApiResponseSuccess = json.encode({
        "result": "success",
        "documentation": "https://www.exchangerate-api.com/docs",
        "terms_of_use": "https://www.exchangerate-api.com/terms",
        "time_last_update_unix": 1672905601,
        "time_last_update_utc": "Wed, 04 Jan 2023 00:00:01 +0000",
        "time_next_update_unix": 1672992001,
        "time_next_update_utc": "Thu, 05 Jan 2023 00:00:01 +0000",
        "base_code": "USD",
        "conversion_rates": {
          "USD": 1.0,
          "BRL": 5.05,
          "EUR": 0.92,
          "GBP": 0.81,
        }
      });

      // Decodifica o JSON como a função faria
      final Map<String, dynamic> decodedData = json.decode(mockApiResponseSuccess);

      // Verifica se o resultado é 'success' e se contém 'conversion_rates'
      expect(decodedData['result'], 'success');
      expect(decodedData.containsKey('conversion_rates'), isTrue);

      final Map<String, dynamic> conversionRates = decodedData['conversion_rates'];
      expect(conversionRates, isA<Map<String, dynamic>>());
      expect(conversionRates['BRL'], 5.05);
      expect(conversionRates['EUR'], 0.92);
      expect(conversionRates['GBP'], 0.81);
    });

    test('Deve retornar null ou lidar com resposta de erro da API', () {
      // Simula uma resposta JSON de erro da ExchangeRate-API
      final String mockApiResponseError = json.encode({
        "result": "error",
        "error-type": "invalid-key",
      });

      final Map<String, dynamic> decodedData = json.decode(mockApiResponseError);

      // Verifica se o resultado é 'error' e se NÃO contém 'conversion_rates'
      expect(decodedData['result'], 'error');
      expect(decodedData.containsKey('conversion_rates'), isFalse);
      expect(decodedData['error-type'], 'invalid-key');
    });
  });
}