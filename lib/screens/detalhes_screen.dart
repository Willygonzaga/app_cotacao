import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String currencyCode;
  final double rate;

  const DetailScreen({
    super.key,
    required this.currencyCode,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$currencyCode Detalhes'), // Título da AppBar com o código da moeda
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Moeda: $currencyCode',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Taxa de Câmbio: 1 USD = ${rate.toStringAsFixed(4)} $currencyCode', // Formata a taxa com 4 casas decimais
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Você pode adicionar mais informações aqui, como data de atualização, etc.
              const Text(
                'Informações adicionais podem ser exibidas aqui (futura implementação).',
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
