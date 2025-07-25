import 'package:flutter/material.dart';

import 'package:app_cotacao/services/api_service.dart';

import 'package:app_cotacao/screens/detalhes_screen.dart';

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
                return Card( // Envolve o ListTile em um Card
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adiciona margem
                  elevation: 4, // Adiciona uma sombra para o efeito de "cartão"
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Bordas arredondadas
                  child: ListTile(
                    leading: const Icon(Icons.currency_exchange, color: Colors.blueGrey), // Ícone à esquerda
                    title: Text(
                      currencyCode,
                      style: const TextStyle(fontWeight: FontWeight.bold), // Texto do título em negrito
                    ),
                    subtitle: Text('1 USD = ${rate.toStringAsFixed(4)} $currencyCode'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16), // Ícone de seta para indicar clicável
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            currencyCode: currencyCode,
                            rate: rate.toDouble(),
                          ),
                        ),
                      );
                    },
                  ),
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
