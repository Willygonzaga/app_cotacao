import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final String currencyCode;
  final double rate;
  final String fullName; // Novo
  final String symbol; // Novo
  final String lastUpdateUtc; // Novo

  const DetailScreen({
    super.key,
    required this.currencyCode,
    required this.rate,
    required this.fullName, // Adicionado ao construtor
    required this.symbol, // Adicionado ao construtor
    required this.lastUpdateUtc, // Adicionado ao construtor
  });

  @override
  Widget build(BuildContext context) {
    // Define o formato da data que vem da API (RFC 1123)
    // O locale 'en_US' é importante para garantir que o parser entenda os nomes dos dias e meses em inglês.
    final DateFormat apiDateFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US');

    // Tenta parsear a data. Se falhar, usa a data atual como fallback.
    DateTime parsedDate;
    try {
      parsedDate = apiDateFormat.parse(lastUpdateUtc).toLocal();
    } catch (e) {
      // Em caso de erro no parsing, usa a data e hora atuais para evitar crash
      parsedDate = DateTime.now();
      if (kDebugMode) {
        print('Erro ao parsear data da API ($lastUpdateUtc): $e');
      }
    }

    // Formata a data para exibição no formato desejado
    final String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('$currencyCode Detalhes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary, // Cor do texto/ícone de voltar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$fullName ($currencyCode)', // Nome completo e código
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Símbolo: $symbol', // Símbolo da moeda
                style: const TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              Text(
                'Taxa de Câmbio: 1 USD = ${rate.toStringAsFixed(4)} $currencyCode',
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Última Atualização: $formattedDate (Local)', // Data formatada
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'Gráficos e mais dados históricos poderiam ser exibidos aqui como uma futura implementação.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
