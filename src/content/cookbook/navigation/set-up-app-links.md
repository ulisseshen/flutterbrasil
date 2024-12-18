---
ia-translate: true
title: Configurar links de aplicativos para Android
description: >-
  Aprenda como configurar links de aplicativos para um
  aplicativo Android construído com Flutter.
---

Deep linking é um mecanismo para iniciar um aplicativo com um URI.
Este URI contém esquema, host e caminho,
e abre o aplicativo para uma tela específica.

:::note
Você sabia que o Flutter DevTools fornece uma
ferramenta de validação de deep link para Android?
Uma versão iOS da ferramenta está em desenvolvimento.
Saiba mais e veja uma demonstração em [Validar deep links][].
:::

[Validar deep links]: /tools/devtools/deep-links

Um _link de aplicativo_ é um tipo de deep link que usa
`http` ou `https` e é exclusivo para dispositivos Android.

Configurar links de aplicativos requer que você possua um domínio web.
Caso contrário, considere usar o [Firebase Hosting][]
ou [GitHub Pages][] como uma solução temporária.

## 1. Personalizar um aplicativo Flutter

Escreva um aplicativo Flutter que possa lidar com um URL de entrada.
Este exemplo usa o pacote [go_router][] para lidar com o roteamento.
A equipe do Flutter mantém o pacote `go_router`.
Ele fornece uma API simples para lidar com cenários complexos de roteamento.

 1. Para criar um novo aplicativo, digite `flutter create <nome-do-app>`:

    ```console
    $ flutter create deeplink_cookbook
    ```

 2. Para incluir o pacote `go_router` no seu aplicativo,
    adicione uma dependência para `go_router` ao projeto:

    Para adicionar o pacote `go_router` como uma dependência,
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
    
    /// Isso lida com '/' e '/details'.
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('Tela Inicial')),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (_, __) => Scaffold(
                appBar: AppBar(title: const Text('Tela de Detalhes')),
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
 3. Adicione a seguinte tag metadata e o filtro de intent dentro da
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
   
    :::note
    Se você usar um plugin de terceiros para lidar com deep links,
    como [app_links][],
    o manipulador de deeplink padrão do Flutter irá
    quebrar esses plugins.
    
    Para optar por não usar o manipulador de deep link padrão do Flutter,
     adicione a seguinte tag metadata:
    ```<meta-data android:name="flutter_deeplinking_enabled" android:value="false" />```
    para optar por não usar o manipulador de deeplink padrão do Flutter
    :::

## 3. Hospedagem do arquivo assetlinks.json

Hospede um arquivo `assetlinks.json` usando um servidor web
com um domínio que você possui. Este arquivo informa ao
navegador móvel qual aplicativo Android abrir em vez
do navegador. Para criar o arquivo,
obtenha o nome do pacote do aplicativo Flutter que você criou na
etapa anterior e a impressão digital sha256 da
chave de assinatura que você usará para construir o APK.

### Nome do pacote

Localize o nome do pacote em `AndroidManifest.xml`,
a propriedade `package` sob a tag `<manifest>`.
Os nomes dos pacotes geralmente estão no formato `com.example.*`.

### Impressão digital sha256

O processo pode variar dependendo de como o apk é assinado.

#### Usando o Google Play App Signing

Você pode encontrar a impressão digital sha256 diretamente no console do
desenvolvedor do Play. Abra seu aplicativo no console do Play,
em **Lançamento> Configuração > Integridade do Aplicativo > Guia Assinatura do Aplicativo**:

<img src="/assets/images/docs/cookbook/set-up-app-links-pdc-signing-key.png" alt="Captura de tela da impressão digital sha256 no console do desenvolvedor do Play" width="50%" />

#### Usando o keystore local

Se você estiver armazenando a chave localmente,
você pode gerar o sha256 usando o seguinte comando:

```console
keytool -list -v -keystore <caminho-para-o-keystore>
```

### assetlinks.json

O arquivo hospedado deve ser semelhante a este:

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

 1. Defina o valor de `package_name` para o ID do seu aplicativo Android.

 2. Defina `sha256_cert_fingerprints` para o valor que você obteve
    na etapa anterior.

 3.  Hospede o arquivo em um URL semelhante ao seguinte:
    `<domínio-web>/.well-known/assetlinks.json`

 4. Verifique se o seu navegador pode acessar este arquivo.

:::note
Se você tiver vários flavors, você pode ter muitos valores sha256_cert_fingerprint
no campo sha256_cert_fingerprints.
Basta adicioná-lo à lista sha256_cert_fingerprints.
:::

## Testando

Você pode usar um dispositivo real ou o emulador para testar um link de aplicativo,
mas primeiro certifique-se de ter executado `flutter run` pelo menos uma vez em
os dispositivos. Isso garante que o aplicativo Flutter esteja instalado.

<img src="/assets/images/docs/cookbook/set-up-app-links-emulator-installed.png" alt="Captura de tela do emulador" width="50%" />

Para testar **apenas** a configuração do aplicativo, use o comando adb:

```console
adb shell 'am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "http://<domínio-web>/details"' \
    <nome do pacote>
```

:::note
Isso não testa se os arquivos da web estão
hospedados corretamente,
o comando inicia o aplicativo mesmo
se os arquivos da web não estiverem presentes.
:::

Para testar **tanto** a configuração web quanto a do aplicativo, você deve clicar em um link
diretamente através do navegador da web ou de outro aplicativo.
Uma maneira é criar um Google Docs, adicionar o link e tocar nele.

Se tudo estiver configurado corretamente, o aplicativo Flutter
será iniciado e exibirá a tela de detalhes:

<img src="/assets/images/docs/cookbook/set-up-app-links-emulator-deeplinked.png" alt="Captura de tela do emulador com deep link" width="50%" />

## Apêndice

Código-fonte: [deeplink_cookbook][]

[deeplink_cookbook]: {{site.github}}/flutter/codelabs/tree/main/deeplink_cookbook
[Firebase Hosting]: {{site.firebase}}/docs/hosting
[go_router]: {{site.pub}}/packages/go_router
[GitHub Pages]: https://pages.github.com
[app_links]: {{site.pub}}/packages/app_links
[Assinando o aplicativo]: /deployment/android#signing-the-app
