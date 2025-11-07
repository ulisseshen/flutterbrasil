---
ia-translate: true
title: Adicione uma Flutter View a um app Android
short-title: Integre via FlutterView
description: Aprenda como realizar integrações avançadas via Flutter Views.
---

:::warning
Integrar via [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
é um uso avançado e requer criar manualmente bindings customizados e específicos da aplicação.
:::

Integrar via [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
requer um pouco mais de trabalho do que via FlutterActivity e FlutterFragment descritos anteriormente.

Fundamentalmente, o framework Flutter no lado Dart requer acesso a vários
eventos e ciclos de vida a nível de activity para funcionar. Como o FlutterView (que
é um [android.view.View]({{site.android-dev}}/reference/android/view/View.html))
pode ser adicionado a qualquer activity que é de propriedade da aplicação do desenvolvedor
e como o FlutterView não tem acesso a eventos a nível de activity, o
desenvolvedor deve fazer a ponte dessas conexões manualmente para o [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html).

Como você escolhe alimentar os eventos das activities de sua aplicação para o FlutterView
será específico para sua aplicação.

## Um exemplo

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-view/add-view-sample.gif'
class="mw-100" alt="Add Flutter View sample video">

Ao contrário dos guias para FlutterActivity e FlutterFragment, a integração
FlutterView pode ser melhor demonstrada com um projeto de exemplo.

Um projeto de exemplo está em [https://github.com/flutter/samples/tree/main/add_to_app/android_view]({{site.repo.samples}}/tree/main/add_to_app/android_view)
para documentar uma integração simples de FlutterView onde FlutterViews são usados
para algumas das células em uma lista RecycleView de cards como visto no gif acima.

## Abordagem geral

A essência geral da integração a nível de FlutterView é que você
deve recriar as várias interações entre sua Activity, o
[`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
e o
[`FlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)
presente no [`FlutterActivityAndFragmentDelegate`](https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
no código de sua própria aplicação.
As conexões feitas no
[`FlutterActivityAndFragmentDelegate`](https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
são feitas automaticamente ao usar uma
[`FlutterActivity`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html)
ou um
[`FlutterFragment`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html),
mas como o [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
neste caso está sendo adicionado a uma `Activity` ou `Fragment` em sua aplicação,
você deve recriar as conexões manualmente.
Caso contrário, o [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
não renderizará nada ou terá outras funcionalidades ausentes.

Uma classe de exemplo
[`FlutterViewEngine`]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt)
mostra uma possível implementação de uma conexão específica da aplicação
entre uma `Activity`, um
[`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
e um [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html).

### APIs a implementar

A implementação mínima absoluta necessária para o Flutter
desenhar qualquer coisa é:

* Chamar [`attachToFlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#attachToFlutterEngine-io.flutter.embedding.engine.FlutterEngine-)
  quando o
  [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
  é adicionado à hierarquia de view de uma `Activity` resumida e está visível; e
* Chamar [`appIsResumed`]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html#appIsResumed--)
  no campo `lifecycleChannel` do [`FlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)
  quando a `Activity` hospedando o
  [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
  está visível.

O inverso
[`detachFromFlutterEngine`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#detachFromFlutterEngine--)
e outros métodos de ciclo de vida na
classe [`LifecycleChannel`]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html)
também devem ser chamados para não vazar recursos quando o
`FlutterView` ou `Activity` não está mais visível.

Além disso, consulte a implementação restante na
classe demo [`FlutterViewEngine`]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt)
ou no
[`FlutterActivityAndFragmentDelegate`](https://cs.opensource.google/flutter/engine/+/main:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
para garantir um funcionamento correto de outros recursos como clipboards,
overlay de UI do sistema, plugins, e assim por diante.
