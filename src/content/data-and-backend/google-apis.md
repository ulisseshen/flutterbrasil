---
ia-translate: true
title: Google APIs
description: Como usar Google APIs com Flutter.
---

<?code-excerpt path-base="googleapis/"?>

O [pacote Google APIs][Google APIs package] expõe dezenas de serviços do Google
que você pode usar em projetos Dart.

Esta página descreve como usar APIs que interagem com
dados do usuário final usando autenticação do Google.

Exemplos de APIs de dados de usuário incluem
[Calendar][], [Gmail][], [YouTube][] e Firebase.

:::note
As únicas APIs que você deve usar diretamente do seu projeto Flutter
são aquelas que acessam dados do usuário usando autenticação do Google.

APIs que requerem [contas de serviço][service accounts] **não devem**
ser usadas diretamente de uma aplicação Flutter.
Fazer isso requer enviar credenciais de serviço como parte
da sua aplicação, o que não é seguro.
Para usar essas APIs,
recomendamos criar um serviço intermediário.
:::

Para adicionar autenticação ao Firebase explicitamente, confira o
codelab [Adicionar um fluxo de autenticação de usuário a um app Flutter usando FirebaseUI][fb-lab]
e a documentação
[Começar com Firebase Authentication no Flutter][fb-auth].

[fb-lab]: {{site.firebase}}/codelabs/firebase-auth-in-flutter-apps
[Calendar]: {{site.pub-api}}/googleapis/latest/calendar_v3/calendar_v3-library.html
[fb-auth]: {{site.firebase}}/docs/auth/flutter/start
[Gmail]: {{site.pub-api}}/googleapis/latest/gmail_v1/gmail_v1-library.html
[Google APIs package]: {{site.pub-pkg}}/googleapis
[service accounts]: https://cloud.google.com/iam/docs/service-account-overview
[YouTube]: {{site.pub-api}}/googleapis/latest/youtube_v3/youtube_v3-library.html

## Visão geral

Para usar Google APIs, siga estas etapas:

1. Escolha a API desejada
1. Habilite a API
1. Autentique e determine o usuário atual
1. Obtenha um cliente HTTP autenticado
1. Crie e use a classe de API desejada

## 1. Escolha a API desejada

A documentação do [`package:googleapis`][] lista
cada API como uma biblioteca Dart separada&emdash;em um
formato `nome_versão`.
Confira [`youtube_v3`][] como exemplo.

Cada biblioteca pode fornecer vários tipos,
mas há uma classe _raiz_ que termina em `Api`.
Para YouTube, é [`YouTubeApi`][].

A classe `Api` não é apenas a que você precisa
instanciar (veja etapa 3), mas também
expõe os escopos que representam as permissões
necessárias para usar a API. Por exemplo,
a [seção Constants][Constants section] da
classe `YouTubeApi` lista os escopos disponíveis.
Para solicitar acesso de leitura (mas não escrita) aos
dados do YouTube de um usuário final, autentique o usuário com
[`youtubeReadonlyScope`][].

<?code-excerpt "lib/main.dart (youtube-import)"?>
```dart
/// Provides the `YouTubeApi` class.
import 'package:googleapis/youtube/v3.dart';
```

[Constants section]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi-class.html#constants
[`package:googleapis`]: {{site.pub-api}}/googleapis
[`youtube_v3`]: {{site.pub-api}}/googleapis/latest/youtube_v3/youtube_v3-library.html
[`YouTubeApi`]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi-class.html
[`youtubeReadonlyScope`]: {{site.pub-api}}/googleapis/latest/youtube_v3/YouTubeApi/youtubeReadonlyScope-constant.html

## 2. Habilite a API

Para usar Google APIs você deve ter uma conta Google
e um projeto Google. Você também
precisa habilitar a API desejada.

Este exemplo habilita [YouTube Data API v3][].
Para detalhes, veja as [instruções de primeiros passos][getting started instructions].

[getting started instructions]: https://cloud.google.com/apis/docs/getting-started
[YouTube Data API v3]: https://console.cloud.google.com/apis/library/youtube.googleapis.com

## 3. Autentique e determine o usuário atual

Use o pacote [google_sign_in][gsi-pkg] para
autenticar usuários com sua identidade Google.
Configure o sign in para cada plataforma que você deseja suportar.

<?code-excerpt "lib/main.dart (google-import)"?>
```dart
/// Provides the `GoogleSignIn` class.
import 'package:google_sign_in/google_sign_in.dart';
```

A funcionalidade do pacote é acessada através de
uma instância estática da classe [`GoogleSignIn`][].
Antes de interagir com a instância,
o método `initialize` deve ser chamado e concluído.

<?code-excerpt "lib/main.dart (init)"?>
```dart
final _googleSignIn = GoogleSignIn.instance;

@override
void initState() {
  super.initState();
  _googleSignIn.initialize();
  // ···
}
```

Uma vez que a inicialização esteja completa, mas antes da autenticação do usuário,
ouça os eventos de autenticação para determinar se um usuário fez login.

<?code-excerpt "lib/main.dart (post-init)" plaster="none"?>
```dart highlightLines=1,7,9-12
GoogleSignInAccount? _currentUser;

@override
void initState() {
  super.initState();
  _googleSignIn.initialize().then((_) {
    _googleSignIn.authenticationEvents.listen((event) {
      setState(() {
        _currentUser = switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          _ => null,
        };
      });
    });
  });
}
```

Depois de estar ouvindo os eventos de autenticação relevantes,
você pode tentar autenticar um usuário previamente conectado.

```dart highlightLines=5-6
void initState() {
  super.initState();
  _googleSignIn.initialize().then((_) {
    // ...
    // Attempt to authenticate a previously signed in user.
    _googleSignIn.attemptLightweightAuthentication();
  });
}
```

Para também permitir que novos usuários se autentiquem,
siga as instruções fornecidas por
[`package:google_sign_in`][gsi-pkg].

Uma vez que um usuário tenha sido autenticado,
você deve obter um cliente HTTP autenticado.

[gsi-pkg]: {{site.pub-pkg}}/google_sign_in
[`GoogleSignIn`]: {{site.pub-api}}/google_sign_in/latest/google_sign_in/GoogleSignIn-class.html

## 4. Obtenha um cliente HTTP autenticado

Depois de ter um usuário conectado, solicite os
tokens de autorização de cliente relevantes usando [`authorizationForScopes`][]
para os escopos de API que seu app requer.

<?code-excerpt "lib/main.dart (scope-authorize)"?>
```dart
const relevantScopes = [YouTubeApi.youtubeReadonlyScope];
final authorization = await currentUser.authorizationClient
    .authorizationForScopes(relevantScopes);
```

:::note
Se seus escopos requerem interação do usuário,
você precisará usar [`authorizeScopes`][] de um manipulador de interação
em vez de `authorizationForScopes`.
:::

Depois de ter os tokens de autorização relevantes,
use a extensão [`authClient`][] de
[`package:extension_google_sign_in_as_googleapis_auth`][] para
configurar um cliente HTTP autenticado com as credenciais relevantes aplicadas.

<?code-excerpt "lib/main.dart (auth-import)"?>
```dart
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
```

<?code-excerpt "lib/main.dart (auth-client)"?>
```dart
final authenticatedClient = authorization!.authClient(
  scopes: relevantScopes,
);
```

[`authorizationForScopes`]: {{site.pub-api}}/google_sign_in/latest/google_sign_in/GoogleSignInAuthorizationClient/authorizationForScopes.html
[`authorizeScopes`]: {{site.pub-api}}/google_sign_in/latest/google_sign_in/GoogleSignInAuthorizationClient/authorizeScopes.html
[`authClient`]: {{site.pub-api}}/extension_google_sign_in_as_googleapis_auth/latest/extension_google_sign_in_as_googleapis_auth/GoogleApisGoogleSignInAuth/authClient.html
[`package:extension_google_sign_in_as_googleapis_auth`]: {{site.pub-pkg}}/extension_google_sign_in_as_googleapis_auth

## 5. Crie e use a classe de API desejada

Use a API para criar o tipo de API desejado e chamar métodos.
Por exemplo:

<?code-excerpt "lib/main.dart (playlist)"?>
```dart
final youTubeApi = YouTubeApi(authenticatedClient);

final favorites = await youTubeApi.playlistItems.list(
  ['snippet'],
  playlistId: 'LL', // Liked List
);
```

## Mais informações

Você pode querer conferir o seguinte:

* O [exemplo do `extension_google_sign_in_as_googleapis_auth`][auth-ex]
  é uma implementação funcional dos conceitos descritos nesta página.

[auth-ex]: {{site.pub-pkg}}/extension_google_sign_in_as_googleapis_auth/example
