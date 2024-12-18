---
ia-translate: true
title: Aproveitando as APIs e frameworks de sistema da Apple
description: >-
  Aprenda sobre os plugins Flutter que oferecem funcionalidades
  equivalentes aos frameworks da Apple.
---

Se você vem do desenvolvimento iOS, pode precisar encontrar
plugins Flutter que ofereçam as mesmas capacidades das bibliotecas de
sistema da Apple. Isso pode incluir acessar o hardware do dispositivo ou
interagir com frameworks específicos como o `HealthKit`.

Para uma visão geral de como o framework SwiftUI se compara ao Flutter,
veja [Flutter para desenvolvedores SwiftUI][].

## Apresentando os plugins Flutter

Dart chama as bibliotecas que contém código específico da plataforma de
_plugins_, abreviação para "pacote de plugin".
Ao desenvolver um aplicativo com Flutter, você usa _plugins_ para
interagir com as bibliotecas do sistema.

Em seu código Dart, você usa a API Dart do plugin para chamar o código
nativo da biblioteca do sistema que está sendo usada. Isso significa que
você pode escrever o código para chamar a API Dart. A API então faz com
que funcione para todas as plataformas que o plugin suporta.

Para saber mais sobre plugins, veja [Usando pacotes][].
Embora esta página tenha links para alguns plugins populares,
você pode encontrar milhares mais, junto com exemplos,
em [pub.dev][].
A tabela a seguir não endossa nenhum plugin específico.
Se você não consegue encontrar um pacote que atenda às suas necessidades,
você pode criar o seu próprio ou
usar os canais de plataforma diretamente no seu projeto.
Para saber mais, confira [Escrevendo código específico da plataforma][].

## Adicionando um plugin ao seu projeto

Para usar um framework Apple dentro do seu projeto nativo,
importe-o para seu arquivo Swift ou Objective-C.

Para adicionar um plugin Flutter, execute `flutter pub add nome_do_pacote`
a partir da raiz do seu projeto.
Isso adiciona a dependência ao seu arquivo [`pubspec.yaml`][].
Depois de adicionar a dependência, adicione uma instrução `import` para o
pacote no seu arquivo Dart.

Você pode precisar alterar as configurações do aplicativo ou a lógica de
inicialização. Se isso for necessário, a página "Readme" do pacote em
[pub.dev][] deve fornecer detalhes.

### Plugins Flutter e Frameworks Apple

| Caso de Uso                                   | Framework ou Classe Apple                                                                  | Plugin Flutter               |
|-----------------------------------------------|--------------------------------------------------------------------------------------------|------------------------------|
| Acessar a biblioteca de fotos                 | `PhotoKit` usando os frameworks `Photos` e `PhotosUI` e `UIImagePickerController`       | [`image_picker`][]           |
| Acessar a câmera                              | `UIImagePickerController` usando o `sourceType` `.camera`                               | [`image_picker`][]           |
| Usar recursos avançados da câmera             | `AVFoundation`                                                                           | [`camera`][]                 |
| Oferecer compras dentro do aplicativo         | `StoreKit`                                                                               | [`in_app_purchase`][][^1]    |
| Processar pagamentos                          | `PassKit`                                                                                | [`pay`][][^2]                |
| Enviar notificações push                      | `UserNotifications`                                                                      | [`firebase_messaging`][][^3] |
| Acessar coordenadas GPS                       | `CoreLocation`                                                                           | [`geolocator`][]             |
| Acessar dados do sensor[^4]                   | `CoreMotion`                                                                             | [`sensors_plus`][]           |
| Fazer requisições de rede                     | `URLSession`                                                                             | [`http`][]                   |
| Armazenar chave-valores                       | `property wrapper` `@AppStorage` e `NSUserDefaults`                                      | [`shared_preferences`][]     |
| Persistir em um banco de dados                | `CoreData` ou SQLite                                                                     | [`sqflite`][]                |
| Acessar dados de saúde                        | `HealthKit`                                                                              | [`health`][]                 |
| Usar machine learning                         | `CoreML`                                                                                 | [`google_ml_kit`][][^5]      |
| Reconhecer texto                              | `VisionKit`                                                                              | [`google_ml_kit`][][^5]      |
| Reconhecer fala                               | `Speech`                                                                                 | [`speech_to_text`][]         |
| Usar realidade aumentada                      | `ARKit`                                                                                  | [`ar_flutter_plugin`][]      |
| Acessar dados meteorológicos                  | `WeatherKit`                                                                             | [`weather`][][^6]            |
| Acessar e gerenciar contatos                 | `Contacts`                                                                               | [`contacts_service`][]       |
| Expor ações rápidas na tela inicial         | `UIApplicationShortcutItem`                                                                | [`quick_actions`][]          |
| Indexar itens na pesquisa Spotlight         | `CoreSpotlight`                                                                          | [`flutter_core_spotlight`][] |
| Configurar, atualizar e comunicar com Widgets | `WidgetKit`                                                                              | [`home_widget`][]            |

{:.table .table-striped .nowrap}

[^1]: Suporta tanto a Google Play Store no Android quanto a Apple App Store no iOS.
[^2]: Adiciona pagamentos Google Pay no Android e pagamentos Apple Pay no iOS.
[^3]: Usa o Firebase Cloud Messaging e se integra com o APNs.
[^4]: Inclui sensores como acelerômetro, giroscópio, etc.
[^5]: Usa o ML Kit do Google e suporta vários recursos como reconhecimento de texto, detecção de rosto, rotulagem de imagem, reconhecimento de marcos e leitura de código de barras. Você também pode criar um modelo personalizado com o Firebase. Para saber mais, veja [Use um modelo TensorFlow Lite personalizado com Flutter][].
[^6]: Usa a [API OpenWeatherMap][]. Existem outros pacotes que podem extrair de diferentes APIs de clima.

[Flutter para desenvolvedores SwiftUI]: /get-started/flutter-for/swiftui-devs
[Usando pacotes]: /packages-and-plugins/using-packages
[pub.dev]: {{site.pub-pkg}}
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`http`]: {{site.pub-pkg}}/http
[`sensors_plus`]: {{site.pub-pkg}}/sensors_plus
[`geolocator`]: {{site.pub-pkg}}/geolocator
[`image_picker`]: {{site.pub-pkg}}/image_picker
[`pubspec.yaml`]: /tools/pubspec
[`quick_actions`]: {{site.pub-pkg}}/quick_actions
[`in_app_purchase`]: {{site.pub-pkg}}/in_app_purchase
[`pay`]: {{site.pub-pkg}}/pay
[`firebase_messaging`]: {{site.pub-pkg}}/firebase_messaging
[`google_ml_kit`]: {{site.pub-pkg}}/google_ml_kit
[Use um modelo TensorFlow Lite personalizado com Flutter]: {{site.firebase}}/docs/ml/flutter/use-custom-models
[`speech_to_text`]: {{site.pub-pkg}}/speech_to_text
[`ar_flutter_plugin`]: {{site.pub-pkg}}/ar_flutter_plugin
[`weather`]: {{site.pub-pkg}}/weather
[`contacts_service`]: {{site.pub-pkg}}/contacts_service
[`health`]: {{site.pub-pkg}}/health
[API OpenWeatherMap]: https://openweathermap.org/api
[`sqflite`]: {{site.pub-pkg}}/sqflite
[Escrevendo código específico da plataforma]: /platform-integration/platform-channels
[`camera`]: {{site.pub-pkg}}/camera
[`flutter_core_spotlight`]: {{site.pub-pkg}}/flutter_core_spotlight
[`home_widget`]: {{site.pub-pkg}}/home_widget
