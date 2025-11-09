---
ia-translate: true
title: Adicione uma Flutter View a um app Android
shortTitle: Integre via FlutterView
description: Aprenda como realizar integrações avançadas via Flutter Views.
---

:::warning
Integrar via [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
é um uso avançado e requer a criação manual de bindings customizados e específicos da aplicação.
:::

Integrar via [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
requer um pouco mais de trabalho do que via FlutterActivity e FlutterFragment descritos anteriormente.

Fundamentalmente, o framework Flutter no lado Dart requer acesso a vários eventos
e ciclos de vida no nível da activity para funcionar. Como o FlutterView (que
é um [android.view.View]({{site.android-dev}}/reference/android/view/View.html))
pode ser adicionado a qualquer activity que pertença à aplicação do desenvolvedor
e como o FlutterView não tem acesso a eventos no nível da activity, o
desenvolvedor deve fazer essa ponte manualmente com o [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html).

Como você escolhe alimentar os eventos das activities da sua aplicação para o FlutterView
será específico da sua aplicação.

## Um exemplo

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-view/add-view-sample.webp' alt="Add Flutter View sample video">

Diferentemente dos guias para FlutterActivity e FlutterFragment, a integração
FlutterView pode ser melhor demonstrada com um projeto de exemplo.

Um projeto de exemplo está em [https://github.com/flutter/samples/tree/main/add_to_app/android_view]({{site.repo.samples}}/tree/main/add_to_app/android_view)
para documentar uma integração simples de FlutterView onde FlutterViews são usadas
para algumas das células em uma lista RecycleView de cards como visto no gif acima.

## Abordagem geral

A essência geral da integração no nível FlutterView é que você
deve recriar as várias interações entre sua Activity, o
[`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
e o
[`FlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)
presentes no [`FlutterActivityAndFragmentDelegate`](https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
no código da sua própria aplicação.
As conexões feitas no
[`FlutterActivityAndFragmentDelegate`](https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
são feitas automaticamente quando usando um
[`FlutterActivity`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html)
ou um
[`FlutterFragment`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html),
mas como o [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
neste caso está sendo adicionado a uma `Activity` ou `Fragment` na sua aplicação,
você deve recriar as conexões manualmente.
Caso contrário, o [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
não renderizará nada ou terá outras funcionalidades faltando.

Um exemplo de classe
[`FlutterViewEngine`]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt)
mostra uma possível implementação de uma conexão específica da aplicação
entre uma `Activity`, um
[`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
e um [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html).

### APIs para implementar

A implementação mínima absoluta necessária para o Flutter
desenhar qualquer coisa é:

* Chamar [`attachToFlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#attachToFlutterEngine-io.flutter.embedding.engine.FlutterEngine-)
  quando o
  [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
  é adicionado à hierarquia de views de uma `Activity` retomada e está visível; e
* Chamar [`appIsResumed`]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html#appIsResumed--)
  no campo `lifecycleChannel` do [`FlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)
  quando a `Activity` que hospeda o
  [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
  está visível.

O reverso
[`detachFromFlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#detachFromFlutterEngine--)
e outros métodos de ciclo de vida na classe
[`LifecycleChannel`]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html)
também devem ser chamados para não vazar recursos quando o
`FlutterView` ou `Activity` não está mais visível.

Além disso, veja a implementação restante na classe demo
[`FlutterViewEngine`]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt)
ou no
[`FlutterActivityAndFragmentDelegate`](https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
para garantir o funcionamento correto de outros recursos como áreas de transferência,
overlay da UI do sistema, plugins, e assim por diante.
