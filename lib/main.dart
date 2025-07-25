import 'package:flutter/material.dart';

import 'package:app_cotacao/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
            final Map<String, dynamic> conversionRates = snapshot.data!;
            // Convertendo o mapa de taxas em uma lista de MapEntry para iterar
            final List<MapEntry<String, dynamic>> currencies = conversionRates.entries.toList();

            // Vamos ordenar as moedas pelo código para uma melhor visualização
            currencies.sort((a, b) => a.key.compareTo(b.key));

            return ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currencyCode = currencies[index].key;
                final rate = currencies[index].value;
                return ListTile(
                  title: Text(currencyCode), // Ex: BRL, EUR
                  subtitle: Text('1 USD = $rate $currencyCode'), // Ex: 1 USD = 5.05 BRL
                  // Você pode adicionar um ícone ou mais estilização aqui
                );
              },
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
