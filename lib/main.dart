import 'package:flutter/material.dart';

import 'package:app_cotacao/services/api_service.dart';

import 'package:app_cotacao/screens/detalhes_screen.dart';

import 'package:app_cotacao/utils/moeda_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Cotação',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade700, // Tom de azul predominante
          brightness: Brightness.light,
          primary: Colors.blue.shade700,
          onPrimary: Colors.white,
          secondary: Colors.blue.shade200,
          onSecondary: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App Cotação'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: ApiService.fetchCurrencies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto estiver carregando, exibe um indicador de progresso
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasError) {
            // Se ocorrer um erro, exibe uma mensagem
            return const Center(child: Text('Erro ao carregar as cotações.'));
          } 
          else if (snapshot.hasData && snapshot.data != null) {
            final Map<String, dynamic> apiResponseData = snapshot.data!; // Renomeado para clareza
            final Map<String, dynamic> conversionRates = apiResponseData['conversion_rates'];
            final String lastUpdateUtc = apiResponseData['time_last_update_utc']; // <--- Extraindo a data

            final List<MapEntry<String, dynamic>> currencies = conversionRates.entries.toList();
            currencies.sort((a, b) => a.key.compareTo(b.key));

            return RefreshIndicator( // Mantendo o RefreshIndicator, se você o adicionou antes
              onRefresh: () async {
                // Para o RefreshIndicator funcionar perfeitamente, MyHomePage precisaria ser um StatefulWidget.
                // Por enquanto, ele apenas mostra a animação. Se quiser funcionalidade completa, me avise para refatorarmos.
                await ApiService.fetchCurrencies(); // Apenas chamando para simular a atualização
                // No StateFulWidget, aqui seria um setState para recarregar o FutureBuilder.
              },
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currencyCode = currencies[index].key;
                  final rate = currencies[index].value;

                  // <--- Novas informações para passar
                  final String fullName = currencyNames[currencyCode] ?? currencyCode; // Pega o nome completo ou o código
                  final String symbol = currencySymbols[currencyCode] ?? currencyCode; // Pega o símbolo ou o código

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Icon(Icons.attach_money, color: Theme.of(context).colorScheme.primary),
                      title: Text(
                        currencyCode,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('1 USD = ${rate.toStringAsFixed(4)} $currencyCode'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              currencyCode: currencyCode,
                              rate: rate.toDouble(),
                              fullName: fullName, // <--- Passando o nome completo
                              symbol: symbol, // <--- Passando o símbolo
                              lastUpdateUtc: lastUpdateUtc, // <--- Passando a data de atualização
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
          else {
            // Se não houver dados, exibe uma mensagem
            return const Center(child: Text('Nenhuma cotação disponível.'));
          }
        },
      ),
    );
  }
}
