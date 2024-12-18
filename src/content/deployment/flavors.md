---
ia-translate: true
title: Criando flavors de um aplicativo Flutter
short-title: Flavors
description: >
  Como criar build flavors específicas para diferentes tipos de release ou ambientes de desenvolvimento.
---

## O que são flavors

Você já se perguntou como configurar diferentes ambientes em seu aplicativo
Flutter?
Flavors (conhecidas como _build configurations_ no iOS e macOS) permitem que
você (o desenvolvedor) crie ambientes separados para seu aplicativo usando a
mesma base de código.
Por exemplo, você pode ter uma flavor para seu aplicativo de produção completo,
outra como um aplicativo "gratuito" limitado, outra para testar recursos
experimentais e assim por diante.

Digamos que você queira fazer versões gratuitas e pagas do seu aplicativo
Flutter.
Você pode usar flavors para configurar ambas as versões do aplicativo
sem escrever dois aplicativos separados.
Por exemplo, a versão gratuita do aplicativo tem funcionalidade básica e
anúncios.
Em contraste, a versão paga tem funcionalidade básica do aplicativo, recursos
extras, estilos diferentes para usuários pagos e nenhum anúncio.

Você também pode usar flavors para o desenvolvimento de recursos.
Se você criou um novo recurso e deseja experimentá-lo,
você pode configurar uma flavor para testá-lo.
Seu código de produção permanece inalterado
até que você esteja pronto para implantar seu novo recurso.

Flavors permitem que você defina configurações em tempo de compilação
e defina parâmetros que são lidos em tempo de execução para personalizar
o comportamento do seu aplicativo.

Este documento orienta você na configuração de flavors do Flutter para iOS,
macOS e Android.

## Configuração do ambiente

Pré-requisitos:

* Xcode instalado
* Um projeto Flutter existente

Para configurar flavors no iOS e macOS, você definirá as build configurations no
Xcode.

## Criando flavors no iOS e macOS

<ol>
<li>

Abra seu projeto no Xcode.

</li>
<li>

Selecione **Product** > **Scheme** > **New Scheme** no menu para
adicionar um novo `Scheme`.

* Um scheme descreve como o Xcode executa diferentes ações.
  Para os fins deste guia, o exemplo _flavor_ e _scheme_ são
  nomeados `free`.
  As build configurations no scheme `free`
  têm o sufixo `-free`.

</li>
<li>

Duplique as build configurations para diferenciar entre as
configurações padrão que já estão disponíveis e as novas configurações
para o scheme `free`.

* Na guia **Info**, no final da lista suspensa **Configurations**,
  clique no botão de adição e duplique
  cada nome de configuração (Debug, Release e Profile).
  Duplique as configurações existentes, uma vez para cada ambiente.

![Imagem do Xcode - Etapa 3](/assets/images/docs/flavors/step3-ios-build-config.png){:width="100%"}

:::note
Suas configurações devem ser baseadas em seu arquivo **Debug.xconfig** ou
**Release.xcconfig**, não no **Pods-Runner.xcconfigs**. Você pode verificar isso
expandindo os nomes das configurações.
:::

</li>
<li>

Para corresponder à flavor free, adicione `-free`
ao final de cada novo nome de configuração.

</li>
<li>

Altere o scheme `free` para corresponder às build configurations já criadas.

* No projeto **Runner**, clique em **Manage Schemes…** e uma janela pop-up
  será aberta.
* Clique duas vezes no scheme free. Na próxima etapa
  (conforme mostrado na captura de tela), você modificará cada scheme
  para corresponder à sua build configuration free:

![Imagem do Xcode - Etapa 5](/assets/images/docs/flavors/step-5-ios-scheme-free.png){:width="100%"}

</li>
</ol>

## Usando flavors no iOS e macOS

Agora que você configurou sua flavor free,
você pode, por exemplo, adicionar diferentes identificadores de pacote do produto por flavor.
Um _bundle identifier_ identifica exclusivamente seu aplicativo.
Neste exemplo, definimos o valor de **Debug-free** como
`com.flavor-test.free`.

<ol>
<li>

Altere o identificador do pacote do aplicativo para diferenciar entre os
schemes.
Em **Product Bundle Identifier**, acrescente `.free` a cada valor de scheme
-free.

![Imagem - Etapa 1 usando flavors.](/assets/images/docs/flavors/step-1-using-flavors-free.png){:width="100%"}

</li>
<li>

Nas **Build Settings**, defina o valor do **Product Name** para corresponder a
cada flavor.
Por exemplo, adicione Debug Free.

![Imagem - Etapa 2 usando flavors.](/assets/images/docs/flavors/step-2-using-flavors-free.png){:width="100%"}

</li>
<li>

Adicione o nome de exibição ao **Info.plist**. Atualize o valor de **Bundle
Display Name** para `$(PRODUCT_NAME)`.

![Imagem - Etapa 3 usando flavors.](/assets/images/docs/flavors/step3-using-flavors.png){:width="100%"}

</li>
</ol>

Agora você configurou sua flavor criando um scheme `free`
no Xcode e definindo as build configurations para esse scheme.

Para obter mais informações, pule para a seção [Iniciando suas flavors de
aplicativo][]
no final deste documento.

### Configurações de plugin

Se seu aplicativo usa um plugin do Flutter, você precisa atualizar
`ios/Podfile` (se estiver desenvolvendo para iOS) e `macos/Podfile` (se estiver
desenvolvendo para macOS).

1. Em `ios/Podfile` e `macos/Podfile`, altere o padrão para
   **Debug**, **Profile** e **Release**
   para corresponder às build configurations do Xcode para o scheme `free`.

```ruby
project 'Runner', {
  'Debug-free' => :debug,
  'Profile-free' => :release,
  'Release-free' => :release,
}
```

## Usando flavors no Android

A configuração de flavors no Android pode ser feita no arquivo **build.gradle**
do seu projeto.

1. Dentro do seu projeto Flutter,
   navegue até **android**/**app**/**build.gradle**.

2. Crie uma [`flavorDimension`][] para agrupar suas flavors de produto
   adicionadas.
   O Gradle não combina flavors de produto que compartilham a mesma
   `dimension`.

3. Adicione um objeto `productFlavors` com as flavors desejadas junto
   com os valores para **dimension**, **resValue**
   e **applicationId** ou **applicationIdSuffix**.

   * O nome do aplicativo para cada build está localizado em **resValue**.
   * Se você especificar um **applicationIdSuffix** em vez de um
     **applicationId**,
     ele é anexado ao "base" application id.

{% tabs "android-build-language" %}
{% tab "Kotlin" %}

```kotlin title="build.gradle.kts"
android {
    // ...
    flavorDimensions += "default"

    productFlavors {
        create("free") {
            dimension = "default"
            resValue(type = "string", name = "app_name", value = "free flavor example")
            applicationIdSuffix = ".free"
        }
    }
}
```

{% endtab %}
{% tab "Groovy" %}

```groovy title="build.gradle"
android {
    // ...
    flavorDimensions "default"

    productFlavors {
        free {
            dimension "default"
            resValue "string", "app_name", "free flavor example"
            applicationIdSuffix ".free"
        }
    }
}
```

{% endtab %}
{% endtabs %}

[`flavorDimension`]: {{site.android-dev}}/studio/build/build-variants#flavor-dimensions

## Configurando configurações de inicialização

Em seguida, adicione um arquivo **launch.json**; isso permite que você execute o
comando
`flutter run --flavor [environment name]`.

No VSCode, configure as configurações de inicialização da seguinte forma:

1. No diretório raiz do seu projeto, adicione uma pasta chamada **.vscode**.
2. Dentro da pasta **.vscode**, crie um arquivo chamado **launch.json**.
3. No arquivo **launch.json**, adicione um objeto de configuração para cada
   flavor.
   Cada configuração tem uma chave **name**, **request**, **type**,
   **program**
   e **args**.

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "free",
      "request": "launch",
      "type": "dart",
      "program": "lib/main_development.dart",
      "args": ["--flavor", "free", "--target", "lib/main_free.dart" ]
    }
  ],
  "compounds": []
}
```

Agora você pode executar o comando do terminal
`flutter run --flavor free` ou você pode configurar uma execução
configuração em seu IDE.

{% comment %}
TODO: Quando disponível, adicione um exemplo de aplicativo.
{% endcomment -%}

## Iniciando suas flavors de aplicativo

1. Depois que as flavors forem configuradas, modifique o código Dart em
**lib** / **main.dart** para consumir as flavors.
2. Teste a configuração usando `flutter run --flavor free`
na linha de comando ou em seu IDE.

Para exemplos de build flavors para [iOS][], [macOS][] e [Android][],
confira os exemplos de teste de integração no [repositório do Flutter][].

## Recuperando a flavor do seu aplicativo em tempo de execução

Do seu código Dart, você pode usar a API [`appFlavor`][] para determinar com qual
flavor seu aplicativo foi construído.

## Agrupando condicionalmente ativos com base na flavor

Se você não estiver familiarizado com como adicionar ativos ao seu aplicativo,
consulte
[Adicionando ativos e imagens][].

Se você tiver ativos que são usados apenas em uma flavor específica em seu
aplicativo, você pode
configurá-los para serem agrupados apenas em seu aplicativo ao construir para
essa flavor.
Isso evita que o tamanho do pacote do seu aplicativo seja inchado por ativos
não utilizados.

Aqui está um exemplo:

```yaml
flutter:
  assets:
    - assets/common/
    - path: assets/free/
      flavors:
        - free
    - path: assets/premium/
      flavors:
        - premium
```

Neste exemplo, os arquivos dentro do diretório `assets/common/` sempre serão
agrupados
quando o aplicativo for construído durante `flutter run` ou `flutter build`.
Arquivos dentro do
diretório `assets/free/` são agrupados _somente_ quando a opção `--flavor` é
definida
como `free`. Da mesma forma, os arquivos dentro do diretório `assets/premium`
são
agrupados _somente_ se `--flavor` estiver definido como `premium`.

## Mais informações

Para obter mais informações sobre como criar e usar flavors, consulte
os seguintes recursos:

* [Build flavors in Flutter (Android and iOS) with different Firebase projects per flavor Flutter Ready to Go][]
* [Flavoring Flutter Applications (Android & iOS)][]
* [How to Setup Flutter & Firebase with Multiple Flavors using the FlutterFire CLI][flutterfireCLI]

### Pacotes

Para pacotes que suportam a criação de flavors, confira os seguintes:

* [`flutter_flavor`][]
* [`flutter_flavorizr`][]

[Iniciando suas flavors de aplicativo]: /deployment/flavors/#launching-your-app-flavors
[repositório do Flutter]: {{site.repo.flutter}}/blob/master/dev/integration_tests/flavors/lib/main.dart
[iOS]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/ios
[macOS]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/macos
[iOS (Xcode)]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/ios
[`appFlavor`]: {{site.api}}/flutter/services/appFlavor-constant.html
[Android]: {{site.repo.flutter}}/tree/master/dev/integration_tests/flavors/android
[Adicionando ativos e imagens]: /ui/assets/assets-and-images
[Build flavors in Flutter (Android and iOS) with different Firebase projects per flavor Flutter Ready to Go]: {{site.medium}}/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b
[Flavoring Flutter Applications (Android & iOS)]: {{site.medium}}/flutter-community/flavoring-flutter-applications-android-ios-ea39d3155346
[flutterfireCLI]: https://codewithandrea.com/articles/flutter-firebase-multiple-flavors-flutterfire-cli/
[`flutter_flavor`]: {{site.pub}}/packages/flutter_flavor
[`flutter_flavorizr`]: {{site.pub}}/packages/flutter_flavorizr
