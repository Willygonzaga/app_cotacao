# App Cotação de Moedas

Aplicativo Flutter desenvolvido para exibir cotações de moedas em tempo real. Ele consome dados de uma API externa e apresenta as informações na tela.

## Funcionalidades

* **Lista de Cotações:** Mostra uma lista de moedas com suas respectivas cotações em relação ao Dólar Americano (USD).
* **Detalhes da Moeda:** Ao clicar em um item da lista, uma tela de detalhes aparece com mais informações sobre a moeda.
* **Consumo de API:** Integração com a `ExchangeRate-API` para obter dados de cotação atualizados.

## Tecnologias Utilizadas

* **Flutter:** Framework para desenvolvimento de aplicativos móveis multiplataforma.
* **Dart:** Linguagem de programação utilizada pelo Flutter.
* **ExchangeRate-API:** API pública para obtenção de taxas de câmbio.

## Como Configurar e Rodar o Projeto

Siga os passos abaixo para configurar e executar o projeto em sua máquina:

### Pré-requisitos

Verifique se tem as seguintes ferramentas instaladas:

* **Flutter SDK:** [Instruções de instalação](https://flutter.dev/docs/get-started/install)
* **IDE (Utilizei o Visual Studio Code):** Com as extensões Flutter e Dart instaladas.
* **Um emulador Android/iOS ou um dispositivo físico:** Para rodar o aplicativo.

### Passos para Execução

1.  **Clone o Repositório:**
    Abra seu terminal ou prompt de comando e execute:
    ```bash
    git clone [https://github.com/Willygonzaga/app_cotacao]
    cd nome-do-seu-projeto-flutter
    ```

2.  **Instale as Dependências:**
    Navegue até o diretório do projeto clonado e execute:
    ```bash
    flutter pub get
    ```

3.  **Execute o Aplicativo:**
    Com um emulador ou dispositivo conectado e configurado, execute:
    ```bash
    flutter run
    ```
    Ou, se estiver usando o VS Code, abra o projeto e pressione `F5`.

## Estrutura do Projeto

* `lib/main.dart`: Ponto de entrada do aplicativo, contém a `MyHomePage` (lista de cotações) e a configuração do tema.
* `lib/services/api_service.dart`: Responsável por fazer as requisições à `ExchangeRate-API`.
* `lib/screens/detalhes_screen.dart`: Tela que exibe os detalhes de uma moeda selecionada.

## Autor

Willy Gonzaga Balieiro