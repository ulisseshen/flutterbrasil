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

## Views dimensionadas pelo conteúdo

Normalmente, uma [`FlutterView`]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
precisa de dimensões fixas, seja por meio de suas próprias dimensões ou correspondendo às
dimensões de um pai. Isso pode ser visto no [projeto de exemplo]({{site.repo.samples}}/tree/main/add_to_app/android_view/android_view).
No entanto, agora é possível permitir que a `FlutterView` se dimensione
com base em seu conteúdo. Usando `content_wrap` para a altura
ou a largura, uma `FlutterView` pode se dimensionar, como mostrado no [projeto de exemplo de dimensionamento pelo conteúdo]({{site.repo.samples}}/tree/main/add_to_app/android_view/content_sizing_android_view).

* Para _habilitar_ views dimensionadas pelo conteúdo ao implantar seu app,
  adicione a seguinte configuração ao arquivo
  `AndroidManifest.xml` do seu projeto, dentro da tag `<application>`:
  
```xml
<meta-data
  android:name="io.flutter.embedding.android.EnableContentSizing"
  android:value="true" />
```

### Restrições

Como as Flutter views dimensionadas pelo conteúdo exigem que seu app Flutter seja capaz de se dimensionar,
alguns widgets não são suportados.

* Um widget com tamanho ilimitado, como uma `ListView`.
* Um widget que delega o tamanho ao seu filho, como `LayoutBuilder`.

Na prática, isso significa que vários widgets comuns não são suportados,
como `ScaffoldBuilder`, `CupertinoTimerPicker`,
ou qualquer widget que dependa internamente de um `LayoutBuilder`.
Em caso de dúvida, você pode usar um `UnconstrainedBox` para testar a usabilidade de
um widget em uma view dimensionada pelo conteúdo, como mostrado no exemplo a seguir:

```dart
import 'package:material_ui/material_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  => MaterialApp(home: MyPage());
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: UnconstrainedBox(
          // TODO: Edit this line to check if a widget
          // can cause problems with content-sized views.
          child: Text('This works!'),
          // child: Column(children: [Column(children: [Expanded(child: Text('This blows up!'))])]),
          // child: ListView(children: [Text('This blows up!')]),
        )
    );
  }
}
```
