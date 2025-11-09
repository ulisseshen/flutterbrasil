---
ia-translate: true
title: Configurar app links para Android
description: >-
  Aprenda como configurar app links para uma
  aplicação Android construída com Flutter.
---

Deep linking é um mecanismo para abrir um app com uma URI.
Esta URI contém esquema, host e caminho,
e abre o app em uma tela específica.

Um _app link_ é um tipo de deep link que usa
`http` ou `https` e é exclusivo para dispositivos Android.

Configurar app links requer possuir um domínio web.
Caso contrário, considere usar [Firebase Hosting][]
ou [GitHub Pages][] como uma solução temporária.

Uma vez que você configurou seus deep links, você pode validá-los.
Para aprender mais, veja [Validate deep links][].

## 1. Personalizar uma aplicação Flutter

Escreva um app Flutter que possa lidar com uma URL de entrada.
Este exemplo usa o pacote [go_router][] para lidar com o roteamento.
A equipe Flutter mantém o pacote `go_router`.
Ele fornece uma API simples para lidar com cenários de roteamento complexos.

 1. Para criar uma nova aplicação, digite `flutter create <app-name>`:

    ```console
    $ flutter create deeplink_cookbook
    ```

 2. Para incluir o pacote `go_router` no seu app,
    adicione uma dependência para `go_router` ao projeto:

    Para adicionar o pacote `go_router` como dependência,
    execute `flutter pub add`:

    ```console
    $ flutter pub add go_router
    ```

 3. Para lidar com o roteamento,
    crie um objeto `GoRouter` no arquivo `main.dart`:

    ```dart title="main.dart"
    import 'package:flutter/material.dart';
    import 'package:go_router/go_router.dart';

    void main() => runApp(MaterialApp.router(routerConfig: router));

    /// This handles '/' and '/details'.
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => Scaffold(
            appBar: AppBar(title: const Text('Home Screen')),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (_, _) => Scaffold(
                appBar: AppBar(title: const Text('Details Screen')),
              ),
            ),
          ],
        ),
      ],
    );
    ```

## 2. Modificar AndroidManifest.xml

 1. Abra o projeto Flutter com VS Code ou Android Studio.
 2. Navegue até o arquivo `android/app/src/main/AndroidManifest.xml`.
 3. Adicione a seguinte tag de metadados e intent filter dentro da
   tag `<activity>` com `.MainActivity`.

    Substitua `example.com` pelo seu próprio domínio web.

    ```xml
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="http" android:host="example.com" />
        <data android:scheme="https" />
    </intent-filter>
    ```

    :::version-note
    Se você usa uma versão do Flutter anterior a 3.27,
    você precisa optar manualmente pelo deep linking
    adicionando a seguinte tag de metadados a `<activity>`:

    ```xml
    <meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
    ```
    :::

    :::note
    Se você usa um plugin de terceiros para lidar com deep links,
    como [app_links][],
    o handler de deeplink padrão do Flutter irá
    quebrar esses plugins.

    Para optar por não usar o handler de deep link padrão do Flutter,
    adicione a seguinte tag de metadados a `<activity>`:

    ```xml
    <meta-data android:name="flutter_deeplinking_enabled" android:value="false" />
    ```
    :::

## 3. Hospedar arquivo assetlinks.json

Hospede um arquivo `assetlinks.json` usando um servidor web
com um domínio que você possui. Este arquivo informa ao
navegador móvel qual aplicação Android abrir em vez
do navegador. Para criar o arquivo,
obtenha o nome do pacote do app Flutter que você criou no
passo anterior e a impressão digital sha256 da
chave de assinatura que você usará para construir o APK.

### Nome do pacote

Localize o nome do pacote em `AndroidManifest.xml`,
a propriedade `package` sob a tag `<manifest>`.
Nomes de pacote geralmente estão no formato `com.example.*`.

### Impressão digital sha256

O processo pode diferir dependendo de como o apk é assinado.

#### Usando assinatura de app do google play

Você pode encontrar a impressão digital sha256 diretamente do
console de desenvolvedor do play. Abra seu app no console do play,
em **Release> Setup > App Integrity> App Signing tab**:

<img src="/assets/images/docs/cookbook/set-up-app-links-pdc-signing-key.png" alt="Screenshot of sha256 fingerprint in play developer console" width="50%" />

#### Usando keystore local

Se você está armazenando a chave localmente,
você pode gerar sha256 usando o seguinte comando:

```console
keytool -list -v -keystore <path-to-keystore>
```

### assetlinks.json

O arquivo hospedado deve se parecer com isto:

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.deeplink_cookbook",
    "sha256_cert_fingerprints":
    ["FF:2A:CF:7B:DD:CC:F1:03:3E:E8:B2:27:7C:A2:E3:3C:DE:13:DB:AC:8E:EB:3A:B9:72:A1:0E:26:8A:F5:EC:AF"]
  }
}]
```

 1. Defina o valor `package_name` para o ID da sua aplicação Android.

 2. Defina sha256_cert_fingerprints para o valor que você obteve
    no passo anterior.

 3.  Hospede o arquivo em uma URL que se assemelhe ao seguinte:
    `<webdomain>/.well-known/assetlinks.json`

 4. Verifique se seu navegador pode acessar este arquivo.

:::note
Se você tem múltiplos flavors, você pode ter muitos valores sha256_cert_fingerprint
no campo sha256_cert_fingerprints.
Apenas adicione-o à lista sha256_cert_fingerprints
:::

## Testando

Você pode usar um dispositivo real ou o Emulador para testar um app link,
mas primeiro certifique-se de ter executado `flutter run` pelo menos uma vez nos
dispositivos. Isso garante que a aplicação Flutter esteja instalada.

<img src="/assets/images/docs/cookbook/set-up-app-links-emulator-installed.png" alt="Emulator screenshot" width="50%" />

Para testar **apenas** a configuração do app, use o comando adb:

```console
adb shell 'am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "http://<web-domain>/details"' \
    <package name>
```

:::note
Isso não testa se os arquivos web estão
hospedados corretamente,
o comando abre o app mesmo
se os arquivos web não estiverem presentes.
:::

Para testar **ambos** configuração web e app, você deve clicar em um link
diretamente através do navegador web ou outro app.
Uma maneira é criar um Google Doc, adicionar o link, e tocar nele.

:::note
Se você está depurando localmente (e não baixando o app da Play Store),
você pode precisar habilitar manualmente o toggle para **Supported web addresses**.
:::

Se tudo estiver configurado corretamente, a aplicação Flutter
abre e exibe a tela de detalhes:

<img src="/assets/images/docs/cookbook/set-up-app-links-emulator-deeplinked.png" alt="Deeplinked Emulator screenshot" width="50%" />

## Apêndice

Código-fonte: [deeplink_cookbook][]

[deeplink_cookbook]: {{site.github}}/flutter/codelabs/tree/main/deeplink_cookbook
[Firebase Hosting]: {{site.firebase}}/docs/hosting
[go_router]: {{site.pub}}/packages/go_router
[GitHub Pages]: https://pages.github.com
[app_links]: {{site.pub}}/packages/app_links
[Signing the app]: /deployment/android#signing-the-app
[Validate deep links]: /tools/devtools/deep-links
