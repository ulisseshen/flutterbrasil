---
ia-translate: true
title: APIs do Google
description: Como usar as APIs do Google com Flutter.
---

<?code-excerpt path-base="googleapis/"?>

O [pacote Google APIs][] expõe dezenas de serviços do Google
que você pode usar em projetos Dart.

Esta página descreve como usar APIs que interagem com
dados do usuário final, usando a autenticação do Google.

Exemplos de APIs de dados do usuário incluem
[Calendário][], [Gmail][], [YouTube][] e Firebase.

:::note
As únicas APIs que você deve usar diretamente do seu projeto Flutter
são aquelas que acessam dados do usuário usando a autenticação do Google.

APIs que requerem [contas de serviço][] **não devem**
ser usadas diretamente de um aplicativo Flutter.
Fazer isso requer o envio de credenciais de serviço como parte
do seu aplicativo, o que não é seguro.
Para usar essas APIs,
recomendamos criar um serviço intermediário.
:::

Para adicionar autenticação ao Firebase explicitamente, confira o
codelab [Adicionar um fluxo de autenticação de usuário a um aplicativo Flutter usando FirebaseUI][fb-lab] e a
documentação [Começar a usar o Firebase Authentication no Flutter][fb-auth].

[fb-lab]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps
[Calendar]: {{site.pub-api}}/googleapis/latest/calendar_v3/calendar_v3-library.html
[fb-auth]: {{site.firebase}}/docs/auth/flutter/start
[Gmail]: {{site.pub-api}}/googleapis/latest/gmail_v1/gmail_v1-library.html
[Google APIs package]: {{site.pub-pkg}}/googleapis
[contas de serviço]: https://cloud.google.com/iam/docs/service-account-overview
[YouTube]: {{site.pub-api}}/googleapis/latest/youtube_v3/youtube_v3-library.html

## Visão Geral

Para usar as APIs do Google, siga estas etapas:

1. Escolha a API desejada
2. Habilite a API
3. Autentique o usuário com os escopos necessários
4. Obtenha um cliente HTTP autenticado
5. Crie e use a classe API desejada

## 1. Escolha a API desejada

A documentação de [package:googleapis][] lista
cada API como uma biblioteca Dart separada&emdash;em um
formato `nome_versão`.
Confira [`youtube_v3`][] como exemplo.

Cada biblioteca pode fornecer muitos tipos,
mas existe uma classe _raiz_ que termina em `Api`.
Para o YouTube, é [`YouTubeApi`][].

A classe `Api` não é apenas a que você precisa
instanciar (veja o passo 3), mas também
expõe os escopos que representam as permissões
necessárias para usar a API. Por exemplo,
a [seção Constantes][] da
classe `YouTubeApi` lista os escopos disponíveis.
Para solicitar acesso para ler (mas não gravar) os dados
do YouTube de um usuário final, autentique o usuário com
[`youtubeReadonlyScope`][].

<?code-excerpt "lib/main.dart (youtube-import)"?>
```dart
/// Fornece a classe `YouTubeApi`.
import 'package:googleapis/youtube/v3.dart';
```

[seção Constantes]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi-class.html#constants
[package:googleapis]: {{site.pub-api}}/googleapis
[`youtube_v3`]: {{site.pub-api}}/googleapis/latest/youtube_v3/youtube_v3-library.html
[`YouTubeApi`]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi-class.html
[`youtubeReadonlyScope`]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi/youtubeReadonlyScope-constant.html

## 2. Habilite a API

Para usar as APIs do Google, você deve ter uma conta do Google
e um projeto do Google. Você também
precisa habilitar a API desejada.

Este exemplo habilita a [API de dados do YouTube v3][].
Para obter detalhes, consulte as [instruções de introdução][].

[instruções de introdução]: https://cloud.google.com/apis/docs/getting-started
[API de dados do YouTube v3]: https://console.cloud.google.com/apis/library/youtube.googleapis.com

## 3. Autentique o usuário com os escopos necessários

Use o pacote [google_sign_in][gsi-pkg] para
autenticar usuários com sua identidade do Google.
Configure o login para cada plataforma que você deseja oferecer suporte.

<?code-excerpt "lib/main.dart (google-import)"?>
```dart
/// Fornece a classe `GoogleSignIn`
import 'package:google_sign_in/google_sign_in.dart';
```

Ao instanciar a classe [`GoogleSignIn`][],
forneça os escopos desejados, conforme discutido
na seção anterior.

<?code-excerpt "lib/main.dart (init)"?>
```dart
final _googleSignIn = GoogleSignIn(
  scopes: <String>[YouTubeApi.youtubeReadonlyScope],
);
```

Siga as instruções fornecidas por
[`package:google_sign_in`][gsi-pkg]
para permitir que um usuário se autentique.

Uma vez autenticado,
você deve obter um cliente HTTP autenticado.

[gsi-pkg]: {{site.pub-pkg}}/google_sign_in
[`GoogleSignIn`]: {{site.pub-api}}/google_sign_in/latest/google_sign_in/GoogleSignIn-class.html

## 4. Obtenha um cliente HTTP autenticado

O pacote [extension_google_sign_in_as_googleapis_auth][]
fornece um [método de extensão][] em `GoogleSignIn`
chamado [`authenticatedClient`][].

<?code-excerpt "lib/main.dart (auth-import)"?>
```dart
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
```

Adicione um listener para [`onCurrentUserChanged`][]
e quando o valor do evento não for `null`,
você pode criar um cliente autenticado.

<?code-excerpt "lib/main.dart (signin-call)"?>
```dart
var httpClient = (await _googleSignIn.authenticatedClient())!;
```

Esta instância de [`Client`][] inclui as
credenciais necessárias ao invocar as classes da API do Google.

[`authenticatedClient`]: {{site.pub-api}}/extension_google_sign_in_as_googleapis_auth/latest/extension_google_sign_in_as_googleapis_auth/GoogleApisGoogleSignInAuth/authenticatedClient.html
[`Client`]: {{site.pub-api}}/http/latest/http/Client-class.html
[extension_google_sign_in_as_googleapis_auth]: {{site.pub-pkg}}/extension_google_sign_in_as_googleapis_auth
[método de extensão]: {{site.dart-site}}/guides/language/extension-methods
[`onCurrentUserChanged`]: {{site.pub-api}}/google_sign_in/latest/google_sign_in/GoogleSignIn/onCurrentUserChanged.html

## 5. Crie e use a classe API desejada

Use a API para criar o tipo de API desejado e chamar métodos.
Por exemplo:

<?code-excerpt "lib/main.dart (playlist)"?>
```dart
var youTubeApi = YouTubeApi(httpClient);

var favorites = await youTubeApi.playlistItems.list(
  ['snippet'],
  playlistId: 'LL', // Lista de curtidas
);
```

## Mais informações

Você pode querer conferir o seguinte:

* O [exemplo `extension_google_sign_in_as_googleapis_auth`][auth-ex]
  é uma implementação funcional dos conceitos descritos nesta página.

[auth-ex]: {{site.pub-pkg}}/extension_google_sign_in_as_googleapis_auth/example
