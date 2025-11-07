---
ia-translate: true
title: Criar flavors de um app Flutter
short-title: Flavors
description: >
  Como criar flavors de build específicos para diferentes
  tipos de release ou ambientes de desenvolvimento.
---

## O que são flavors

Você já se perguntou como configurar diferentes ambientes no seu app Flutter?
Flavors (conhecidos como _build configurations_ no iOS e macOS), permitem que você (o desenvolvedor)
crie ambientes separados para seu app usando a mesma base de código.
Por exemplo, você pode ter um flavor para seu app de produção completo,
outro como um app "gratuito" limitado, outro para testar recursos experimentais, e assim por diante.

Digamos que você queira fazer versões gratuitas e pagas do seu app Flutter.
Você pode usar flavors para configurar ambas as versões do app
sem escrever dois apps separados.
Por exemplo, a versão gratuita do app tem funcionalidades básicas e anúncios.
Em contraste, a versão paga tem funcionalidades básicas do app, recursos extras,
estilos diferentes para usuários pagos e sem anúncios.

Você também pode usar flavors para desenvolvimento de recursos.
Se você construiu um novo recurso e quer experimentá-lo,
você pode configurar um flavor para testá-lo.
Seu código de produção permanece inalterado
até que você esteja pronto para implantar seu novo recurso.

Flavors permitem que você defina configurações em tempo de compilação
e defina parâmetros que são lidos em tempo de execução para personalizar
o comportamento do seu app.

Este documento guia você através da configuração de flavors Flutter para iOS, macOS e Android.

## Configuração do ambiente

Pré-requisitos:

* Xcode instalado
* Um projeto Flutter existente

Para configurar flavors no iOS e macOS, você definirá build configurations no Xcode.

## Criando flavors no iOS e macOS

<ol>
<li>

Abra seu projeto no Xcode.

</li>
<li>

Selecione **Product** > **Scheme** > **New Scheme** do menu para
adicionar um novo `Scheme`.

* Um scheme descreve como o Xcode executa diferentes ações.
  Para os propósitos deste guia, o exemplo de _flavor_ e _scheme_ são
  nomeados `free`.
  As build configurations no scheme `free`
  têm o sufixo `-free`.

</li>
<li>

Duplique as build configurations para diferenciar entre as
configurações padrão que já estão disponíveis e as novas configurações
para o scheme `free`.

* Sob a aba **Info** no final da lista suspensa **Configurations**,
  clique no botão de mais e duplique
  cada nome de configuração (Debug, Release e Profile).
  Duplique as configurações existentes, uma para cada ambiente.

![Step 3 Xcode image](/assets/images/docs/flavors/step3-ios-build-config.png){:width="100%"}

:::note
Suas configurações devem ser baseadas no seu arquivo **Debug.xconfig** ou **Release.xcconfig**,
não nos **Pods-Runner.xcconfigs**. Você pode verificar isso expandindo os nomes de configuração.
:::

</li>
<li>

Para corresponder ao flavor free, adicione `-free`
no final de cada novo nome de configuração.

</li>
<li>

Altere o scheme `free` para corresponder às build configurations já criadas.

* No projeto **Runner**, clique em **Manage Schemes…** e uma janela pop-up abre.
* Dê duplo clique no scheme free. Na próxima etapa
  (como mostrado na captura de tela), você modificará cada scheme
  para corresponder à sua build configuration free:

![Step 5 Xcode image](/assets/images/docs/flavors/step-5-ios-scheme-free.png){:width="100%"}

</li>
</ol>

## Usando flavors no iOS e macOS

Agora que você configurou seu flavor free,
você pode, por exemplo, adicionar diferentes identificadores de pacote de produto por flavor.
Um _bundle identifier_ identifica exclusivamente sua aplicação.
Neste exemplo, definimos o valor **Debug-free** igual a
`com.flavor-test.free`.

<ol>
<li>

Altere o bundle identifier do app para diferenciar entre schemes.
Em **Product Bundle Identifier**, anexe `.free` a cada valor de scheme -free.

![Step 1 using flavors image.](/assets/images/docs/flavors/step-1-using-flavors-free.png){:width="100%"}

</li>
<li>

Nas **Build Settings**, defina o valor **Product Name** para corresponder a cada flavor.
Por exemplo, adicione Debug Free.

![Step 2 using flavors image.](/assets/images/docs/flavors/step-2-using-flavors-free.png){:width="100%"}

</li>
<li>

Adicione o nome de exibição ao **Info.plist**. Atualize o valor **Bundle Display Name**
para `$(PRODUCT_NAME)`.

![Step 3 using flavors image.](/assets/images/docs/flavors/step3-using-flavors.png){:width="100%"}

</li>
</ol>

Agora você configurou seu flavor criando um scheme `free`
no Xcode e definindo as build configurations para esse scheme.

Para mais informações, pule para a seção [Iniciando seus flavors de app][Launching your app flavors]
no final deste documento.

### Configurações de plugin

Se seu app usa um plugin Flutter, você precisa atualizar
`ios/Podfile` (se desenvolvendo para iOS) e `macos/Podfile` (se desenvolvendo para macOS).

1. Em `ios/Podfile` e `macos/Podfile`, altere o padrão para
   **Debug**, **Profile**, e **Release**
   para corresponder às build configurations do Xcode para o scheme `free`.

```ruby
project 'Runner', {
  'Debug-free' => :debug,
  'Profile-free' => :release,
  'Release-free' => :release,
}
```

## Usando flavors no Android

Configurar flavors no Android pode ser feito no arquivo
**build.gradle** do seu projeto.

1. Dentro do seu projeto Flutter,
   navegue até **android**/**app**/**build.gradle**.

2. Crie uma [`flavorDimension`][] para agrupar seus product flavors adicionados.
   O Gradle não combina product flavors que compartilham a mesma `dimension`.

3. Adicione um objeto `productFlavors` com os flavors desejados junto
   com valores para **dimension**, **resValue**,
   e **applicationId** ou **applicationIdSuffix**.

   * O nome da aplicação para cada build está localizado em **resValue**.
   * Se você especificar um **applicationIdSuffix** em vez de um **applicationId**,
     ele é anexado ao application id "base".

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

## Configurando launch configurations

Em seguida, adicione um arquivo **launch.json**; isso permite que você execute o comando
`flutter run --flavor [environment name]`.

No VSCode, configure as launch configurations da seguinte forma:

1. No diretório raiz do seu projeto, adicione uma pasta chamada **.vscode**.
2. Dentro da pasta **.vscode**, crie um arquivo chamado **launch.json**.
3. No arquivo **launch.json**, adicione um objeto de configuração para cada flavor.
   Cada configuração tem uma chave **name**, **request**, **type**, **program**,
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

Você pode agora executar o comando do terminal
`flutter run --flavor free` ou pode configurar uma run
configuration no seu IDE.

{% comment %}
TODO: When available, add an app sample.
{% endcomment -%}

## Iniciando seus flavors de app

1. Uma vez que os flavors estão configurados, modifique o código Dart em
**lib** / **main.dart** para consumir os flavors.
2. Teste a configuração usando `flutter run --flavor free`
na linha de comando, ou no seu IDE.

Para exemplos de build flavors para [iOS][], [macOS][], e [Android][],
confira as amostras de teste de integração no [repositório Flutter][Flutter repo].

## Recuperando o flavor do seu app em tempo de execução

Do seu código Dart, você pode usar a API [`appFlavor`][] para determinar com qual
flavor seu app foi compilado.

## Agrupando assets condicionalmente com base no flavor

Se você não está familiarizado com como adicionar assets ao seu app, veja
[Adicionando assets e imagens][Adding assets and images].

Se você tem assets que são usados apenas em um flavor específico no seu app, você pode
configurá-los para serem agrupados apenas no seu app ao compilar para esse flavor.
Isso evita que o tamanho do bundle do seu app seja inflado por assets não utilizados.

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

Neste exemplo, arquivos dentro do diretório `assets/common/` sempre serão agrupados
quando o app for compilado durante `flutter run` ou `flutter build`. Arquivos dentro do
diretório `assets/free/` são agrupados _apenas_ quando a opção `--flavor` é definida
como `free`. Similarmente, arquivos dentro do diretório `assets/premium` são
agrupados _apenas_ se `--flavor` for definido como `premium`.

## Mais informações

Para mais informações sobre criar e usar flavors, confira
os seguintes recursos:

* [Build flavors in Flutter (Android and iOS) with different Firebase projects per flavor Flutter Ready to Go][]
* [Flavoring Flutter Applications (Android & iOS)][]
* [How to Setup Flutter & Firebase with Multiple Flavors using the FlutterFire CLI][flutterfireCLI]

### Pacotes

Para pacotes que suportam a criação de flavors, confira o seguinte:

* [`flutter_flavor`][]
* [`flutter_flavorizr`][]

[Launching your app flavors]: /deployment/flavors/#launching-your-app-flavors
[Flutter repo]: {{site.repo.flutter}}/blob/main/dev/integration_tests/flavors/lib/main.dart
[iOS]: {{site.repo.flutter}}/tree/main/dev/integration_tests/flavors/ios
[macOS]: {{site.repo.flutter}}/tree/main/dev/integration_tests/flavors/macos
[iOS (Xcode)]: {{site.repo.flutter}}/tree/main/dev/integration_tests/flavors/ios
[`appFlavor`]: {{site.api}}/flutter/services/appFlavor-constant.html
[Android]: {{site.repo.flutter}}/tree/main/dev/integration_tests/flavors/android
[Adding assets and images]: /ui/assets/assets-and-images
[Build flavors in Flutter (Android and iOS) with different Firebase projects per flavor Flutter Ready to Go]: {{site.medium}}/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b
[Flavoring Flutter Applications (Android & iOS)]: {{site.medium}}/flutter-community/flavoring-flutter-applications-android-ios-ea39d3155346
[flutterfireCLI]: https://codewithandrea.com/articles/flutter-firebase-multiple-flavors-flutterfire-cli/
[`flutter_flavor`]: {{site.pub}}/packages/flutter_flavor
[`flutter_flavorizr`]: {{site.pub}}/packages/flutter_flavorizr
