---
title: Configurando a estratégia de URL na web
description: Use estratégias de URL hash ou path na web
ia-translate: true
---

Os aplicativos web Flutter suportam duas maneiras de configurar
a navegação baseada em URL na web:

**Hash (padrão)**
: Os caminhos são lidos e escritos no [fragmento hash][].
Por exemplo, `flutterexample.dev/#/path/to/screen`.

**Path**
:  Os caminhos são lidos e escritos sem um hash. Por exemplo,
`flutterexample.dev/path/to/screen`.

## Configurando a estratégia de URL

Para configurar o Flutter para usar o path, use a
função [usePathUrlStrategy][] fornecida pela biblioteca [flutter_web_plugins][],
que faz parte do Flutter SDK.

Você não pode adicionar `flutter_web_plugins` diretamente usando `pub add`.
Inclua-o como uma [dependência do SDK][] do Flutter em seu arquivo `pubspec.yaml`:

```yaml highlightLines=4-5
dependencies:
  flutter:
    sdk: flutter
  flutter_web_plugins:
    sdk: flutter
```

Em seguida, chame a função `usePathUrlStrategy` antes de `runApp`:

```dart highlightLines=4
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(ExampleApp());
}
```

[dependência do SDK]: {{site.dart-site}}/tools/pub/dependencies#sdk

## Configurando seu servidor web

PathUrlStrategy usa a [History API][], que requer configuração adicional
para servidores web.

Para configurar seu servidor web para suportar PathUrlStrategy, consulte a
documentação do seu servidor web para reescrever solicitações para `index.html`.
Consulte a documentação do seu servidor web para obter detalhes sobre como
configurar aplicativos de página única.

Se você estiver usando Firebase Hosting, escolha a opção "Configure as a single-page app"
ao inicializar seu projeto. Para mais informações, consulte a documentação
[Configure rewrites][] do Firebase.

O servidor de desenvolvimento local criado ao executar `flutter run -d chrome` é configurado para
lidar com qualquer caminho graciosamente e fazer fallback para o arquivo `index.html` do seu aplicativo.

## Hospedando um aplicativo Flutter em uma localização não raiz

Atualize a tag `<base href="/">` em `web/index.html`
para o caminho onde seu aplicativo está hospedado.
Por exemplo, para hospedar seu aplicativo Flutter em
`my_app.dev/flutter_app`, altere
esta tag para `<base href="/flutter_app/">`.

Tags `base href` relativas são suportadas para builds de release, mas elas devem levar
em consideração a URL completa de onde a página foi servida.
Isso significa que um `base href` relativo para uma solicitação para `/flutter_app/`,
`/flutter_app/nested/route` e `/flutter_app/nested/route/` será diferente
(por exemplo `"."`, `".."` e `"../.."` respectivamente).

[fragmento hash]: https://en.wikipedia.org/wiki/Uniform_Resource_Locator#Syntax
[`HashUrlStrategy`]: {{site.api}}/flutter/flutter_web_plugins/HashUrlStrategy-class.html
[`PathUrlStrategy`]: {{site.api}}/flutter/flutter_web_plugins/PathUrlStrategy-class.html
[`setUrlStrategy`]: {{site.api}}/flutter/flutter_web_plugins/setUrlStrategy.html
[`url_strategy`]: {{site.pub-pkg}}/url_strategy
[usePathUrlStrategy]: {{site.api}}/flutter/flutter_web_plugins/usePathUrlStrategy.html
[flutter_web_plugins]: {{site.api}}/flutter/flutter_web_plugins/flutter_web_plugins-library.html
[History API]: https://developer.mozilla.org/en-US/docs/Web/API/History_API
[Configure rewrites]: {{site.firebase}}/docs/hosting/full-config#rewrites
