---
ia-translate: true
title: Adicionar um Flutter Fragment a um app Android
shortTitle: Adicionar um Flutter Fragment
description: Aprenda como adicionar um Flutter Fragment ao seu app Android existente.
---

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-fragment/add-flutter-fragment_header.png' alt="Add Flutter Fragment Header">

Este guia descreve como adicionar um `Fragment` Flutter a um app
Android existente. No Android, um [`Fragment`][`Fragment`] representa uma parte modular
de uma UI maior. Um `Fragment` pode ser usado para apresentar
uma gaveta deslizante, conteúdo com abas, uma página em um `ViewPager`,
ou pode simplesmente representar uma tela normal em um
app de `Activity` única. O Flutter fornece um [`FlutterFragment`][`FlutterFragment`]
para que desenvolvedores possam apresentar uma experiência Flutter em qualquer lugar
onde possam usar um `Fragment` comum.

Se uma `Activity` é igualmente aplicável para as necessidades do seu aplicativo,
considere [usar uma `FlutterActivity`][using a `FlutterActivity`] em vez de um
`FlutterFragment`, que é mais rápido e fácil de usar.

`FlutterFragment` permite que desenvolvedores controlem os seguintes
detalhes da experiência Flutter dentro do `Fragment`:

 * Rota inicial do Flutter
 * Entrypoint Dart a ser executado
 * Background opaco vs translúcido
 * Se `FlutterFragment` deve controlar sua `Activity` ao redor
 * Se um novo [`FlutterEngine`][`FlutterEngine`] ou um `FlutterEngine` em cache deve ser usado

`FlutterFragment` também vem com várias chamadas que
devem ser encaminhadas de sua `Activity` ao redor.
Essas chamadas permitem que o Flutter reaja apropriadamente a eventos do SO.

Todas as variedades de `FlutterFragment`, e seus requisitos,
são descritas neste guia.

## Adicionar um `FlutterFragment` a uma `Activity` com um novo `FlutterEngine`

A primeira coisa a fazer para usar um `FlutterFragment` é adicioná-lo a uma `Activity`
hospedeira.

Para adicionar um `FlutterFragment` a uma `Activity` hospedeira, instancie e
anexe uma instância de `FlutterFragment` em `onCreate()` dentro da
`Activity`, ou em outro momento que funcione para seu app:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyActivity.kt"
class MyActivity : FragmentActivity() {
  companion object {
    // Define a tag String to represent the FlutterFragment within this
    // Activity's FragmentManager. This value can be whatever you'd like.
    private const val TAG_FLUTTER_FRAGMENT = "flutter_fragment"
  }

  // Declare a local variable to reference the FlutterFragment so that you
  // can forward calls to it later.
  private var flutterFragment: FlutterFragment? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)

    // Inflate a layout that has a container for your FlutterFragment. For
    // this example, assume that a FrameLayout exists with an ID of
    // R.id.fragment_container.
    setContentView(R.layout.my_activity_layout)

    // Get a reference to the Activity's FragmentManager to add a new
    // FlutterFragment, or find an existing one.
    val fragmentManager: FragmentManager = supportFragmentManager

    // Attempt to find an existing FlutterFragment, in case this is not the
    // first time that onCreate() was run.
    flutterFragment = fragmentManager
      .findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?

    // Create and attach a FlutterFragment if one does not exist.
    if (flutterFragment == null) {
      var newFlutterFragment = FlutterFragment.createDefault()
      flutterFragment = newFlutterFragment
      fragmentManager
        .beginTransaction()
        .add(
          R.id.fragment_container,
          newFlutterFragment,
          TAG_FLUTTER_FRAGMENT
        )
        .commit()
    }
  }
}
```

</Tab>
<Tab name="Java">

```java title="MyActivity.java"
public class MyActivity extends FragmentActivity {
    // Define a tag String to represent the FlutterFragment within this
    // Activity's FragmentManager. This value can be whatever you'd like.
    private static final String TAG_FLUTTER_FRAGMENT = "flutter_fragment";

    // Declare a local variable to reference the FlutterFragment so that you
    // can forward calls to it later.
    private FlutterFragment flutterFragment;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Inflate a layout that has a container for your FlutterFragment.
        // For this example, assume that a FrameLayout exists with an ID of
        // R.id.fragment_container.
        setContentView(R.layout.my_activity_layout);

        // Get a reference to the Activity's FragmentManager to add a new
        // FlutterFragment, or find an existing one.
        FragmentManager fragmentManager = getSupportFragmentManager();

        // Attempt to find an existing FlutterFragment,
        // in case this is not the first time that onCreate() was run.
        flutterFragment = (FlutterFragment) fragmentManager
            .findFragmentByTag(TAG_FLUTTER_FRAGMENT);

        // Create and attach a FlutterFragment if one does not exist.
        if (flutterFragment == null) {
            flutterFragment = FlutterFragment.createDefault();

            fragmentManager
                .beginTransaction()
                .add(
                    R.id.fragment_container,
                    flutterFragment,
                    TAG_FLUTTER_FRAGMENT
                )
                .commit();
        }
    }
}
```

</Tab>
</Tabs>

O código anterior é suficiente para renderizar uma UI Flutter
que começa com uma chamada ao seu entrypoint Dart `main()`,
uma rota inicial do Flutter `/`, e um novo `FlutterEngine`.
No entanto, este código não é suficiente para alcançar todo o
comportamento esperado do Flutter. O Flutter depende de vários sinais do SO que
devem ser encaminhados da sua `Activity` hospedeira para o `FlutterFragment`.
Essas chamadas são mostradas no exemplo a seguir:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyActivity.kt"
class MyActivity : FragmentActivity() {
  override fun onPostResume() {
    super.onPostResume()
    flutterFragment!!.onPostResume()
  }

  override fun onNewIntent(@NonNull intent: Intent) {
    flutterFragment!!.onNewIntent(intent)
  }

  override fun onBackPressed() {
    flutterFragment!!.onBackPressed()
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<String?>,
    grantResults: IntArray
  ) {
    flutterFragment!!.onRequestPermissionsResult(
      requestCode,
      permissions,
      grantResults
    )
  }

  override fun onActivityResult(
    requestCode: Int,
    resultCode: Int,
    data: Intent?
  ) {
    super.onActivityResult(requestCode, resultCode, data)
    flutterFragment!!.onActivityResult(
      requestCode,
      resultCode,
      data
    )
  }

  override fun onUserLeaveHint() {
    flutterFragment!!.onUserLeaveHint()
  }

  override fun onTrimMemory(level: Int) {
    super.onTrimMemory(level)
    flutterFragment!!.onTrimMemory(level)
  }
}
```

</Tab>
<Tab name="Java">

```java title="MyActivity.java"
public class MyActivity extends FragmentActivity {
    @Override
    public void onPostResume() {
        super.onPostResume();
        flutterFragment.onPostResume();
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        flutterFragment.onNewIntent(intent);
    }

    @Override
    public void onBackPressed() {
        flutterFragment.onBackPressed();
    }

    @Override
    public void onRequestPermissionsResult(
        int requestCode,
        @NonNull String[] permissions,
        @NonNull int[] grantResults
    ) {
        flutterFragment.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        );
    }

    @Override
    public void onActivityResult(
        int requestCode,
        int resultCode,
        @Nullable Intent data
    ) {
        super.onActivityResult(requestCode, resultCode, data);
        flutterFragment.onActivityResult(
            requestCode,
            resultCode,
            data
        );
    }

    @Override
    public void onUserLeaveHint() {
        flutterFragment.onUserLeaveHint();
    }

    @Override
    public void onTrimMemory(int level) {
        super.onTrimMemory(level);
        flutterFragment.onTrimMemory(level);
    }
}
```

</Tab>
</Tabs>

Com os sinais do SO encaminhados para o Flutter,
seu `FlutterFragment` funciona como esperado.
Você agora adicionou um `FlutterFragment` ao seu app Android existente.

O caminho de integração mais simples usa um novo `FlutterEngine`,
que vem com um tempo de inicialização não trivial,
levando a uma UI em branco até que o Flutter seja
inicializado e renderizado pela primeira vez.
A maior parte dessa sobrecarga de tempo pode ser evitada usando
um `FlutterEngine` em cache e pré-aquecido, que é discutido a seguir.

## Usando um `FlutterEngine` pré-aquecido

Por padrão, um `FlutterFragment` cria sua própria instância
de um `FlutterEngine`, que requer um tempo de aquecimento não trivial.
Isso significa que seu usuário vê um `Fragment` em branco por um breve momento.
Você pode mitigar a maior parte deste tempo de aquecimento usando
uma instância existente e pré-aquecida de `FlutterEngine`.

Para usar um `FlutterEngine` pré-aquecido em um `FlutterFragment`,
instancie um `FlutterFragment` com o método factory `withCachedEngine()`.

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyApplication.kt"
// Somewhere in your app, before your FlutterFragment is needed,
// like in the Application class ...
// Instantiate a FlutterEngine.
val flutterEngine = FlutterEngine(context)

// Start executing Dart code in the FlutterEngine.
flutterEngine.getDartExecutor().executeDartEntrypoint(
    DartEntrypoint.createDefault()
)

// Cache the pre-warmed FlutterEngine to be used later by FlutterFragment.
FlutterEngineCache
  .getInstance()
  .put("my_engine_id", flutterEngine)
```

```kotlin title="MyActivity.java"
FlutterFragment.withCachedEngine("my_engine_id").build()
```

</Tab>
<Tab name="Java">

```java title="MyApplication.java"
// Somewhere in your app, before your FlutterFragment is needed,
// like in the Application class ...
// Instantiate a FlutterEngine.
FlutterEngine flutterEngine = new FlutterEngine(context);

// Start executing Dart code in the FlutterEngine.
flutterEngine.getDartExecutor().executeDartEntrypoint(
    DartEntrypoint.createDefault()
);

// Cache the pre-warmed FlutterEngine to be used later by FlutterFragment.
FlutterEngineCache
  .getInstance()
  .put("my_engine_id", flutterEngine);
```

```java title="MyActivity.java"
FlutterFragment.withCachedEngine("my_engine_id").build();
```

</Tab>
</Tabs>

`FlutterFragment` internamente conhece sobre [`FlutterEngineCache`][`FlutterEngineCache`]
e recupera o `FlutterEngine` pré-aquecido com base no ID
fornecido para `withCachedEngine()`.

Ao fornecer um `FlutterEngine` pré-aquecido,
como mostrado anteriormente, seu app renderiza o
primeiro frame Flutter o mais rápido possível.

#### Rota inicial com um engine em cache

{% render "docs/add-to-app/android-initial-route-cached-engine.md" %}

## Exibir uma splash screen

A exibição inicial do conteúdo Flutter requer algum tempo de espera,
mesmo se um `FlutterEngine` pré-aquecido for usado.
Para ajudar a melhorar a experiência do usuário em torno
deste breve período de espera, o Flutter suporta a
exibição de uma splash screen (também conhecida como "launch screen") até que o Flutter
renderize seu primeiro frame. Para instruções sobre como mostrar uma launch
screen, consulte o [guia de splash screen][splash screen guide].

## Executar Flutter com uma rota inicial especificada

Um app Android pode conter muitas experiências Flutter independentes,
executando em diferentes `FlutterFragment`s, com diferentes
`FlutterEngine`s. Nestes cenários,
é comum que cada experiência Flutter comece com diferentes
rotas iniciais (rotas diferentes de `/`).
Para facilitar isso, o `Builder` de `FlutterFragment`
permite que você especifique uma rota inicial desejada, como mostrado:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyActivity.kt"
// With a new FlutterEngine.
val flutterFragment = FlutterFragment.withNewEngine()
    .initialRoute("myInitialRoute/")
    .build()
```

</Tab>
<Tab name="Java">

```java title="MyActivity.java"
// With a new FlutterEngine.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .initialRoute("myInitialRoute/")
    .build();
```

</Tab>
</Tabs>

:::note
A propriedade de rota inicial de `FlutterFragment` não tem efeito quando um
`FlutterEngine` pré-aquecido é usado porque o `FlutterEngine` pré-aquecido já
escolheu uma rota inicial. A rota inicial pode ser escolhida explicitamente ao
pré-aquecer um `FlutterEngine`.
:::

## Executar Flutter a partir de um entrypoint especificado

Semelhante a variar rotas iniciais, diferentes
`FlutterFragment`s podem querer executar diferentes
entrypoints Dart. Em um app Flutter típico, existe apenas um
entrypoint Dart: `main()`, mas você pode definir outros entrypoints.

`FlutterFragment` suporta a especificação do
entrypoint Dart desejado para executar para a experiência Flutter fornecida.
Para especificar um entrypoint, construa `FlutterFragment`, como mostrado:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyActivity.kt"
val flutterFragment = FlutterFragment.withNewEngine()
    .dartEntrypoint("mySpecialEntrypoint")
    .build()
```

</Tab>
<Tab name="Java">

```java title="MyActivity.java"
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .dartEntrypoint("mySpecialEntrypoint")
    .build();
```

</Tab>
</Tabs>

A configuração de `FlutterFragment` resulta na execução
de um entrypoint Dart chamado `mySpecialEntrypoint()`.
Observe que os parênteses `()` não estão
incluídos no nome `String` de `dartEntrypoint`.

:::note
A propriedade de entrypoint Dart de `FlutterFragment` não tem efeito
quando um `FlutterEngine` pré-aquecido é usado porque o
`FlutterEngine` pré-aquecido já executou um entrypoint Dart.
O entrypoint Dart pode ser escolhido explicitamente ao pré-aquecer
um `FlutterEngine`.
:::

## Controlar o modo de renderização de `FlutterFragment`

`FlutterFragment` pode usar um `SurfaceView` para renderizar seu
conteúdo Flutter, ou pode usar um `TextureView`.
O padrão é `SurfaceView`, que é significativamente
melhor para performance do que `TextureView`. No entanto, `SurfaceView`
não pode ser intercalado no meio de uma hierarquia de `View` do Android.
Um `SurfaceView` deve ser a `View` mais inferior na hierarquia,
ou a `View` mais superior na hierarquia.
Além disso, em versões do Android anteriores ao Android N,
`SurfaceView`s não podem ser animados porque seu layout e renderização
não estão sincronizados com o resto da hierarquia de `View`.
Se qualquer um destes casos de uso são requisitos para seu app,
então você precisa usar `TextureView` em vez de `SurfaceView`.
Selecione um `TextureView` construindo um `FlutterFragment` com um
`RenderMode` `texture`:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyActivity.kt"
// With a new FlutterEngine.
val flutterFragment = FlutterFragment.withNewEngine()
    .renderMode(FlutterView.RenderMode.texture)
    .build()

// With a cached FlutterEngine.
val flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .renderMode(FlutterView.RenderMode.texture)
    .build()
```

</Tab>
<Tab name="Java">

```java title="MyActivity.java"
// With a new FlutterEngine.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .renderMode(FlutterView.RenderMode.texture)
    .build();

// With a cached FlutterEngine.
FlutterFragment flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .renderMode(FlutterView.RenderMode.texture)
    .build();
```

</Tab>
</Tabs>

Usando a configuração mostrada, o `FlutterFragment` resultante
renderiza sua UI para um `TextureView`.

## Exibir um `FlutterFragment` com transparência

Por padrão, `FlutterFragment` renderiza com um background opaco,
usando um `SurfaceView`. (Veja "Controlar o modo de renderização de `FlutterFragment`".)
Esse background é preto para quaisquer pixels que não são
pintados pelo Flutter. Renderizar com um background opaco é
o modo de renderização preferido por razões de performance.
A renderização do Flutter com transparência no Android afeta negativamente
a performance. No entanto, existem muitos designs que
requerem pixels transparentes na experiência Flutter que
aparecem através da UI Android subjacente. Por esta razão,
o Flutter suporta translucidez em um `FlutterFragment`.

:::note
Tanto `SurfaceView` quanto `TextureView` suportam transparência.
No entanto, quando um `SurfaceView` é instruído a renderizar com
transparência, ele se posiciona em um z-index mais alto do que
todas as outras `View`s do Android, o que significa que aparece
acima de todas as outras `View`s. Esta é uma limitação de `SurfaceView`.
Se for aceitável renderizar sua experiência Flutter no topo
de todo o outro conteúdo, então o `RenderMode` padrão de `FlutterFragment`
de `surface` é o `RenderMode` que você
deve usar. No entanto, se você precisar exibir `View`s do Android tanto
acima quanto abaixo de sua experiência Flutter, então você deve especificar um
`RenderMode` de `texture`.
Veja "Controlar o modo de renderização de `FlutterFragment`"
para informações sobre controlar o `RenderMode`.
:::

Para habilitar transparência para um `FlutterFragment`,
construa-o com a seguinte configuração:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyActivity.kt"
// Using a new FlutterEngine.
val flutterFragment = FlutterFragment.withNewEngine()
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build()

// Using a cached FlutterEngine.
val flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build()
```

</Tab>
<Tab name="Java">

```java title="MyActivity.java"
// Using a new FlutterEngine.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build();

// Using a cached FlutterEngine.
FlutterFragment flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .transparencyMode(FlutterView.TransparencyMode.transparent)
    .build();
```

</Tab>
</Tabs>

## A relação entre `FlutterFragment` e sua `Activity`

Alguns apps escolhem usar `Fragment`s como telas Android inteiras.
Nestes apps, seria razoável para um `Fragment`
controlar o chrome do sistema como a barra de status do Android,
barra de navegação e orientação.

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-fragment/add-flutter-fragment_fullscreen.png' alt="Fullscreen Flutter">

Em outros apps, `Fragment`s são usados para representar apenas
uma parte de uma UI. Um `FlutterFragment` pode ser usado para
implementar o interior de uma gaveta, um player de vídeo,
ou um único card. Nestas situações, seria
inapropriado para o `FlutterFragment` afetar
o chrome do sistema do Android porque existem outras partes da UI
dentro da mesma `Window`.

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-fragment/add-flutter-fragment_partial-ui.png' alt="Flutter as Partial UI">

`FlutterFragment` vem com um conceito que ajuda
a diferenciar entre o caso quando um `FlutterFragment`
deve ser capaz de controlar sua `Activity` hospedeira, e os
casos quando um `FlutterFragment` deve afetar apenas seu
próprio comportamento. Para prevenir que um `FlutterFragment`
exponha sua `Activity` para plugins Flutter, e para
prevenir que o Flutter controle a UI do sistema da `Activity`,
use o método `shouldAttachEngineToActivity()` no
`Builder` de `FlutterFragment`, como mostrado:

<Tabs key="android-language">
<Tab name="Kotlin">

```kotlin title="MyActivity.kt"
// Using a new FlutterEngine.
val flutterFragment = FlutterFragment.withNewEngine()
    .shouldAttachEngineToActivity(false)
    .build()

// Using a cached FlutterEngine.
val flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .shouldAttachEngineToActivity(false)
    .build()
```

</Tab>
<Tab name="Java">

```java title="MyActivity.java"
// Using a new FlutterEngine.
FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
    .shouldAttachEngineToActivity(false)
    .build();

// Using a cached FlutterEngine.
FlutterFragment flutterFragment = FlutterFragment.withCachedEngine("my_engine_id")
    .shouldAttachEngineToActivity(false)
    .build();
```

</Tab>
</Tabs>

Passar `false` para o método `shouldAttachEngineToActivity()`
do `Builder` previne que o Flutter interaja com
a `Activity` ao redor. O valor padrão é `true`,
que permite que o Flutter e plugins Flutter interajam com a
`Activity` ao redor.

:::note
Alguns plugins podem esperar ou requerer uma referência de `Activity`.
Certifique-se de que nenhum dos seus plugins requer uma `Activity`
antes de desabilitar o acesso.
:::

[`Fragment`]: {{site.android-dev}}/guide/components/fragments
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
[using a `FlutterActivity`]: /add-to-app/android/add-flutter-screen
[`FlutterEngine`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[`FlutterEngineCache`]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngineCache.html
[splash screen guide]: /platform-integration/android/splash-screen
