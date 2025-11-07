---
ia-translate: true
title: Aproveitando APIs e frameworks do sistema Apple
description: >-
  Aprenda sobre plugins Flutter que oferecem funcionalidades
  equivalentes aos frameworks da Apple.
---

Quando você vem do desenvolvimento iOS, pode precisar encontrar
plugins Flutter que oferecem as mesmas capacidades das bibliotecas do sistema
da Apple. Isso pode incluir acessar hardware do dispositivo ou interagir
com frameworks específicos como `HealthKit`.

Para uma visão geral de como o framework SwiftUI se compara ao Flutter,
veja [Flutter for SwiftUI developers][].

## Introdução aos plugins Flutter

Dart chama bibliotecas que contêm código específico de plataforma de _plugins_,
abreviação de "plugin package".
Ao desenvolver um app com Flutter, você usa _plugins_ para interagir
com bibliotecas do sistema.

No seu código Dart, você usa a API Dart do plugin para chamar o código nativo
da biblioteca do sistema sendo usada. Isso significa que você pode escrever
o código para chamar a API Dart. A API então faz funcionar para todas
as plataformas que o plugin suporta.

Para saber mais sobre plugins, veja [Using packages][].
Embora esta página faça link para alguns plugins populares,
você pode encontrar milhares de outros, junto com exemplos,
no [pub.dev][].
A tabela a seguir não endossa nenhum plugin em particular.
Se você não encontrar um pacote que atenda às suas necessidades,
você pode criar o seu próprio ou
usar platform channels diretamente no seu projeto.
Para saber mais, confira [Writing platform-specific code][].

## Adicionando um plugin ao seu projeto

Para usar um framework Apple dentro do seu projeto nativo,
importe-o no seu arquivo Swift ou Objective-C.

Para adicionar um plugin Flutter, execute `flutter pub add package_name`
a partir da raiz do seu projeto.
Isso adiciona a dependência ao seu arquivo [`pubspec.yaml`][].
Depois de adicionar a dependência, adicione uma declaração `import` para o pacote
no seu arquivo Dart.

Você pode precisar alterar configurações do app ou lógica de inicialização.
Se isso for necessário, a página "Readme" do pacote no [pub.dev][]
deve fornecer detalhes.

### Plugins Flutter e Frameworks Apple

| Caso de Uso                                      | Framework ou Classe Apple                                                             | Plugin Flutter               |
|--------------------------------------------------|---------------------------------------------------------------------------------------|------------------------------|
| Acessar a biblioteca de fotos                    | `PhotoKit` usando os frameworks `Photos` e `PhotosUI ` e `UIImagePickerController`   | [`image_picker`][]           |
| Acessar a câmera                                 | `UIImagePickerController` usando o `sourceType` `.camera`                             | [`image_picker`][]           |
| Usar recursos avançados de câmera                | `AVFoundation`                                                                        | [`camera`][]                 |
| Oferecer compras dentro do app                   | `StoreKit`                                                                            | [`in_app_purchase`][][^1]    |
| Processar pagamentos                             | `PassKit`                                                                             | [`pay`][][^2]                |
| Enviar notificações push                         | `UserNotifications`                                                                   | [`firebase_messaging`][][^3] |
| Acessar coordenadas GPS                          | `CoreLocation`                                                                        | [`geolocator`][]             |
| Acessar dados de sensores[^4]                    | `CoreMotion`                                                                          | [`sensors_plus`][]           |
| Fazer requisições de rede                        | `URLSession`                                                                          | [`http`][]                   |
| Armazenar key-values                             | Property wrapper `@AppStorage` e `NSUserDefaults`                                     | [`shared_preferences`][]     |
| Persistir em um banco de dados                   | `CoreData` ou SQLite                                                                  | [`sqflite`][]                |
| Acessar dados de saúde                           | `HealthKit`                                                                           | [`health`][]                 |
| Usar machine learning                            | `CoreML`                                                                              | [`google_ml_kit`][][^5]      |
| Reconhecer texto                                 | `VisionKit`                                                                           | [`google_ml_kit`][][^5]      |
| Reconhecer fala                                  | `Speech`                                                                              | [`speech_to_text`][]         |
| Usar realidade aumentada                         | `ARKit`                                                                               | [`ar_flutter_plugin`][]      |
| Acessar dados meteorológicos                     | `WeatherKit`                                                                          | [`weather`][][^6]            |
| Acessar e gerenciar contatos                     | `Contacts`                                                                            | [`contacts_service`][]       |
| Expor ações rápidas na tela inicial              | `UIApplicationShortcutItem`                                                           | [`quick_actions`][]          |
| Indexar itens na busca do Spotlight              | `CoreSpotlight`                                                                       | [`flutter_core_spotlight`][] |
| Configurar, atualizar e se comunicar com Widgets | `WidgetKit`                                                                           | [`home_widget`][]            |

{:.table .table-striped .nowrap}

[^1]: Suporta tanto Google Play Store no Android quanto Apple App Store no iOS.
[^2]: Adiciona pagamentos Google Pay no Android e pagamentos Apple Pay no iOS.
[^3]: Usa Firebase Cloud Messaging e se integra com APNs.
[^4]: Inclui sensores como acelerômetro, giroscópio, etc.
[^5]: Usa o ML Kit do Google e suporta vários recursos como reconhecimento de texto, detecção de rosto, rotulagem de imagem, reconhecimento de marco e leitura de código de barras. Você também pode criar um modelo personalizado com Firebase. Para saber mais, veja [Use a custom TensorFlow Lite model with Flutter][].
[^6]: Usa a [API OpenWeatherMap][OpenWeatherMap API]. Outros pacotes existem que podem obter dados de diferentes APIs de clima.

[Flutter for SwiftUI developers]: /get-started/flutter-for/swiftui-devs
[Using packages]: /packages-and-plugins/using-packages
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
[Use a custom TensorFlow Lite model with Flutter]: {{site.firebase}}/docs/ml/flutter/use-custom-models
[`speech_to_text`]: {{site.pub-pkg}}/speech_to_text
[`ar_flutter_plugin`]: {{site.pub-pkg}}/ar_flutter_plugin
[`weather`]: {{site.pub-pkg}}/weather
[`contacts_service`]: {{site.pub-pkg}}/contacts_service
[`health`]: {{site.pub-pkg}}/health
[OpenWeatherMap API]: https://openweathermap.org/api
[`sqflite`]: {{site.pub-pkg}}/sqflite
[Writing platform-specific code]: /platform-integration/platform-channels
[`camera`]: {{site.pub-pkg}}/camera
[`flutter_core_spotlight`]: {{site.pub-pkg}}/flutter_core_spotlight
[`home_widget`]: {{site.pub-pkg}}/home_widget
